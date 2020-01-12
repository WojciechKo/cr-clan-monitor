require 'types'

module ActivityMeter
  class ActivityRepository
    def find_clan_war_acticity(clan_tag)
      clan = Clan.find_by(tag: clan_tag)

      raise Helpers::ApiError::NotFound unless clan

      clan_members = Player
        .includes(:membership)
        .where(memberships: { clan: clan })
        .order('tag DESC')
        .to_a

      last_10_clan_wars = War
        .eager_load(:participations)
        .where(clan: clan)
        .order('wars.created_at desc')
        .limit(10)
        .to_a

      ClanWarActivity.new(
        tag:     clan.tag,
        name:    clan.name,
        members: clan_members.map(&build_members(last_10_clan_wars))
      )
    end

    private

    def build_members(wars)
      lambda do |player|
        { tag:               player.tag,
          username:          player.username,
          trophies:          player.trophies,
          level:             player.level,
          donated:           player.membership.donated,
          received:          player.membership.received,
          rank:              player.membership.rank,
          war_participation: wars.map(&extract_war_participation(player.membership)) }
      end
    end

    def extract_war_participation(membership)
      lambda do |war|
        participation = war.participations
          .find { |p| p.membership_id == membership.id }

        if participation
          { cards_collected: participation.cards_collected }
        else
          { cards_collected: 0 }
        end
      end
    end

    class ClanWarActivity < Types::Struct
      attribute :tag,     Types::Strict::String
      attribute :name,    Types::Strict::String
      attribute :members, Types::Strict::Array do
        attribute :tag,               Types::Strict::String
        attribute :username,          Types::Strict::String
        attribute :trophies,          Types::Strict::Integer
        attribute :level,             Types::Strict::Integer
        attribute :donated,           Types::Strict::Integer
        attribute :received,          Types::Strict::Integer
        attribute :rank,              Types::MemberRank
        attribute :war_participation, Types::Strict::Array do
          attribute :cards_collected, Types::Strict::Integer
        end
      end
    end
  end
end
