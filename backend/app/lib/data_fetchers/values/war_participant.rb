require 'types'

module DataFetchers
  module Values
    class WarParticipant < Types::Struct
      attribute :name,               Types::Strict::String
      attribute :tag,                Types::Strict::String
      attribute :collection_battles, Types::Strict::Integer
      attribute :war_battles,        Types::Strict::Array.of(Types::Battle)
      attribute :cards_collected,    Types::Strict::Integer
    end
  end
end
