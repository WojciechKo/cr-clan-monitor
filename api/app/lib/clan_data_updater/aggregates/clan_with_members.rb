require 'types'
require_relative 'member'

module ClanDataUpdater
  module Aggregates
    class ClanWithMembers < Types::Struct
      attribute :id,   Types::Id.maybe
      attribute :tag,  Types::Strict::String
      attribute :name, Types::Strict::String

      attribute :current_members, Types::Array.of(Member).default { [] }
      attribute :new_members,     Types::Array.of(Member).default { [] }
      attribute :lost_members,    Types::Array.of(Member).default { [] }

      def update(clan)
        grouped_members_to_save = clan.members.group_by(&if_new_member?)

        members_to_update = (grouped_members_to_save[false] || [])
          .map(&Member.serialize)
        members_to_create = (grouped_members_to_save[true] || [])
          .map(&Member.serialize)

        members_to_delete = current_members.reject(&member_of?(clan))

        new(
          name:            clan.name,
          current_members: members_to_update,
          new_members:     members_to_create,
          lost_members:    members_to_delete
        )
      end

      class << self
        def build_from_model(model)
          members = model.memberships.map do |membership|
            player = membership.player
            { tag:      player.tag,
              level:    player.level,
              username: player.username,
              trophies: player.trophies,
              donated:  membership.donated,
              received: membership.received,
              rank:     membership.rank }
          end

          new(id:              model.id,
              tag:             model.tag,
              name:            model.name,
              current_members: members)
        end

        def build_new(clan)
          new(
            tag:             clan.tag,
            name:            clan.name,
            current_members: [],
            new_members:     clan.members.map(&Member.serialize)
          )
        end
      end

      private

      def if_new_member?
        ->(current_member) { current_members.none? { |m| m.tag == current_member.tag } }
      end

      def member_of?(clan)
        ->(member) { clan.members.any? { |m| m.tag == member.tag } }
      end
    end
  end
end
