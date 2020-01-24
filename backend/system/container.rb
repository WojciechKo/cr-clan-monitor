require 'dry/system/container'

class Container < Dry::System::Container
  configure do |config|
    config.root          = 'app'
    config.auto_register = ['lib']
  end

  load_paths!('lib', '../system')
end

Container.register(:logger) do
  logger_target = if ENV['LOG_TO_STDOUT']
    STDOUT
  else
    "./log/#{ENV['RAILS_ENV']}.log"
  end

  logger = ActiveSupport::Logger.new(logger_target)
  logger.formatter = ::Logger::Formatter.new
  ActiveSupport::TaggedLogging.new(logger)
end
