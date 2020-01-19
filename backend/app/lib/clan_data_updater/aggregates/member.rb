require 'types'

module ClanDataUpdater
  module Aggregates
    class Member < Types::Struct
      attribute :tag,      Types::Strict::String
      attribute :username, Types::Strict::String
      attribute :level,    Types::Strict::Integer
      attribute :donated,  Types::Strict::Integer
      attribute :received, Types::Strict::Integer
      attribute :rank,     Types::MemberRank
      attribute :trophies, Types::Strict::Integer

      def self.serialize
        lambda do |member|
          new(tag:      member.tag,
              username: member.username,
              level:    member.level,
              donated:  member.donated,
              received: member.received,
              rank:     member.rank,
              trophies: member.trophies)
        end
      end
    end
  end
end
