require 'types'
require_relative 'war_participation'

module ActivityMeter
  module Values
    class MemberActivity < Types::Struct
      attribute :tag,                Types::Strict::String
      attribute :wars_participation, Types::Strict::Array.of(WarParticipation)
    end
  end
end
