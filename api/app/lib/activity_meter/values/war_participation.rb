require 'types'

module ActivityMeter
  module Values
    class WarParticipation < Types::Struct
      attribute :collection_day do
        attribute :cards_collected, Types::Strict::Integer
        attribute :battles_count,   Types::Strict::Integer
      end

      attribute :war_day do
        attribute :battles, Types::Strict::Array.of(Types::Battle)
      end
    end
  end
end
