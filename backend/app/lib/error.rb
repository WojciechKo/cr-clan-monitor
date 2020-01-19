require 'types'

class Error < Types::Struct
  attribute :error,   Types::Strict::Symbol.default(:unknown_error)
  attribute :message, Types::Strict::String.default('Something went wrong'.freeze)
  attribute :meta,    Types::Any.default(nil)

  def exception
    RuntimeError.new(message)
  end

  def self.unknown_error
    new(error:   :unknown_error,
        message: 'Unknown error')
  end
end
