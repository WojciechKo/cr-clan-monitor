require 'monads'
require 'dry-matcher'

module Operation
  def self.included(klass)
    klass.class_eval do
      include Monads::Result::Mixin
      include Monads::Do.for(:call)
      include Dry::Matcher.for(:call, with: Matcher)
    end
  end

  Matcher = Dry::Matcher.new(
    success: Dry::Matcher::Case.new(
      match:   lambda { |result, *patterns|
        result = result.to_result
        result.success? && (patterns.empty? || patterns.any? { |p| p === result.value! })
      },
      resolve: ->(result) { result.to_result.value! }
    ),
    failure: Dry::Matcher::Case.new(
      match:   lambda { |result, *patterns|
        result = result.to_result
        result.failure? && (patterns.empty? || patterns.any? { |p| p === result.failure })
      },
      resolve: ->(result) { result.to_result.failure }
    )
  )
end
