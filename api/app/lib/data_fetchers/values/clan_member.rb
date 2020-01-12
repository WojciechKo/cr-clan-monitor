require 'types'

module DataFetchers
  module Values
    class ClanMember < Types::Struct
      attribute :tag,       Types::Strict::String
      attribute :username,  Types::Strict::String
      attribute :last_seen, Types::Strict::String
      attribute :rank,      Types::MemberRank
      attribute :trophies,  Types::Strict::Integer
      attribute :level,     Types::Strict::Integer
      attribute :donated,   Types::Strict::Integer
      attribute :received,  Types::Strict::Integer
    end
  end
end
