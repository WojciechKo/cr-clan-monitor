require 'worker'
require 'import'

module ClanDataUpdater
  class ClanMembersWorker
    include Worker
    sidekiq_options lock:        :until_and_while_executing,
                    on_conflict: :replace

    include Import[
      'clan_data_updater.clan_members_updater',
      'logger'
    ]

    def perform(clan_tag)
      yield update_clan_members(clan_tag)
      yield schedule_next_update(clan_tag)
    end

    private

    def update_clan_members(clan_tag)
      clan_members_updater.call(clan_tag)
        .or(&handle_update_failure)
    end

    def handle_update_failure
      lambda do |failure|
        log_failure(failure)
        retry_if_may_succeed!(failure)
      end
    end

    def log_failure(failure)
      logger.warn(failure.message)
    end

    def retry_if_may_succeed!(failure)
      case failure
        when ClanDataUpdater::Errors::ClanNotFound then Failure(failure)
        else raise failure
      end
    end

    def schedule_next_update(clan_tag)
      ClanMembersWorker.perform_in(2.hours, clan_tag)
      Success()
    end
  end
end
