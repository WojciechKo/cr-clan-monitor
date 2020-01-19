require 'types'
require_relative 'war'

module DataFetchers
  module Values
    class WarLog < Types::Struct
      attribute :wars, Types::Strict::Array.of(War)
    end
  end
end
