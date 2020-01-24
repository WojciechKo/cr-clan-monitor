require 'monads'
require 'import'
require_relative 'errors'

module ClanDataUpdater
  class ClanMembersRepository
    include Monads::Result::Mixin

    include Import['logger']

    def find_by_tag(clan_tag)
      clan = Clan
        .includes(:memberships)
        .find_by(tag: clan_tag)

      return Failure(Errors::ClanNotFound.new) unless clan

      aggregate = Aggregates::ClanWithMembers.build_from_model(clan)
      Success(aggregate)
    end

    def store(clan)
      clan_id = store_clan_details(clan)
      update_current_members(clan, clan_id)
      store_new_members(clan, clan_id)
      delete_lost_members(clan)
    end

    private

    def store_clan_details(clan)
      clan_model = Clan.new(tag: clan.tag, name: clan.name)
      logger.debug 'clan_details - # '
      result = Clan.import(
        [clan_model],
        on_duplicate_key_update: {
          conflict_target: [:tag],
          columns:         [:name]
        }
      )
      logger.debug 'clan_details - # '
      clan_model.id
    end

    def update_current_members(clan, clan_id)
      players = clan.current_members.map do |member|
        Player.new(
          tag:      member.tag,
          level:    member.level,
          trophies: member.trophies,
          username: member.username
        )
      end

      logger.debug 'update - # '

      result = Player.import(
        players,
        on_duplicate_key_update: {
          conflict_target: [:tag],
          columns:         [:level, :trophies, :username]
        }
      )

      if result.failed_instances.empty?
        memberships = clan.current_members.zip(result.ids).map do |member, player_id|
          Membership.new(
            player_id: player_id,
            clan_id:   clan_id,
            donated:   member.donated,
            received:  member.received,
            rank:      member.rank
          )
        end

        Membership.import(
          memberships,
          on_duplicate_key_update: {
            conflict_target: [:clan_id, :player_id],
            columns:         [:donated, :received, :rank]
          }
        )
      end

      logger.debug 'update - $ '
    end

    def store_new_members(clan, clan_id)
      new_members_in_the_clan = clan.new_members.map do |member|
        Player.new(
          tag:      member.tag,
          level:    member.level,
          trophies: member.trophies,
          username: member.username
        ).tap do |player|
          player.build_membership(
            clan_id:  clan_id,
            donated:  member.donated,
            received: member.received,
            rank:     member.rank
          )
        end
      end

      logger.debug 'new - # '
      Player.import(
        new_members_in_the_clan,
        on_duplicate_key_update: {
          conflict_target: [:tag]
        },
        recursive:               true
      )
      logger.debug 'new - $ '
    end

    def delete_lost_members(clan)
      clan.lost_members.map(&:tag)
        .then { |tags| Player.where(tag: tags) }
        .then { |player_ids| Membership.where(player_id: player_ids).delete_all }
        .then { Success() }
    end
  end
end
