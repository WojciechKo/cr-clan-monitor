require 'dry-types'

Dry::Types.load_extensions(:maybe)

module Types
  include Dry.Types()
  Struct = Dry::Struct

  Id = Types::Strict::Integer
  Tag = Types::Strict::String
  MemberRank = Types::Coercible::Symbol.enum(:member, :elder, :co_leader, :leader)
  Battle = Types::Strict::Symbol.enum(:win, :loss, :not_participated)
end
