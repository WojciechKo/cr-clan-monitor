require 'sidekiq'

module Worker
  def self.included(base)
    base.class_eval do
      include Sidekiq::Worker
      include Monads::Result::Mixin
      include Monads::Do.for(:perform)
    end
  end
end
