RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.url_whitelist = ['postgresql://postgres@postgres/cr-clan-monitor']

    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
