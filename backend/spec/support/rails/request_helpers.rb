module RequestHelpers
  def parse_response
    JSON.parse(response.body)
  end

  def get_json(url)
    get(url)
    parse_response
  end
end

RSpec.configure do |config|
  config.include RequestHelpers
end

