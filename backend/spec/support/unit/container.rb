require 'dry/system/stubs'

Container.enable_stubs!

RSpec.shared_context :mock_import do |name, value|
  before do
    # Resolve dependency to create the key
    Container.resolve(name)

    # Stub the dependency under given key
    Container.stub(name, send(value))
  end

  after do
    Container.unstub
  end
end
