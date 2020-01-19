require 'dry/system/container'

class Container < Dry::System::Container
  configure do |config|
    config.root          = 'app'
    config.auto_register = ['lib']
  end

  load_paths!('lib', '../system')
end

Container.register(:logger) do
  if Kernel.const_defined?('Rails')
    Rails.logger
  else
    Logger.new(STDOUT)
  end
end
