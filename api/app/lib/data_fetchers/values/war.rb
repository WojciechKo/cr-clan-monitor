require 'types'
require_relative 'war_participant'

module DataFetchers
  module Values
    class War < Types::Struct
      attribute :started_at,      Types::Strict::String
      attribute :cards_collected, Types::Strict::Integer
      attribute :participants,    Types::Strict::Hash.map(
        Types::Tag,
        WarParticipant
      )
    end
  end
end
