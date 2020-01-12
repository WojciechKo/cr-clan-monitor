require 'types'
require_relative 'clan_member'

module DataFetchers
  module Values
    class ClanInfo < Types::Struct
      attribute :name,    Types::Strict::String
      attribute :tag,     Types::Strict::String
      attribute :members, Types::Strict::Array.of(ClanMember)
    end
  end
end
