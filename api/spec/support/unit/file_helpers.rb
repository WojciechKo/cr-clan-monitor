module FileHelpers
  def fixture_content(path)
    File.read(Pathname(__dir__).join('../../fixtures/files').join(path))
  end
end

RSpec.configure do |config|
  config.include FileHelpers
end
