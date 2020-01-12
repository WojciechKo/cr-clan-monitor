require 'operation'
require 'import'

module ClanDataUpdater
  class ClanMembersUpdater
    include Operation
    include Import[
      'data_fetchers.clan_info_fetcher',
      'clan_data_updater.clan_members_repository'
    ]

    def call(clan_tag)
      clan_info = yield fetch_clan_info(clan_tag)
      clan      = yield update_or_create_clan(clan_tag, clan_info)
      clan_members_repository.store(clan)
    end

    private

    def fetch_clan_info(clan_tag)
      clan_info_fetcher.call(clan_tag)
        .or do |failure|
          case failure
            when DataFetchers::Errors::ClanNotFound
              Failure(Errors::ClanNotFound.build(clan_tag))
            else
              Failure(failure)
          end
        end
    end

    def update_or_create_clan(clan_tag, clan_info)
      clan_members_repository.find_by_tag(clan_tag)
        .fmap { |clan| clan.update(clan_info) }
        .or_fmap { new_clan(clan_info) }
    end

    def new_clan(clan_info)
      Aggregates::ClanWithMembers.build_new(clan_info)
    end
  end
end
