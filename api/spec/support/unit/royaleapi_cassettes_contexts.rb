RSpec.shared_context :royaleapi_clan_cassette do
  let(:clan_tag) { 'Y8YU8L08' }

  around do |e|
    VCR.use_cassette('royaleapi/pierwsza_liga/clan', &e)
  end
end

RSpec.shared_context :royaleapi_clan_failure_cassette do
  let(:clan_tag) { 'fdsnauivhdpvfdhjklfdsal' }

  around do |e|
    VCR.use_cassette('royaleapi/pierwsza_liga/clan_failure', &e)
  end
end

RSpec.shared_context :royaleapi_clan_timeout_failure do
  let(:clan_tag) { 'connection-error-clan-tag' }

  around do |e|
    VCR.turned_off do
      stub_request(:any, //).to_timeout
      e.call
    end
  end
end

RSpec.shared_context :royaleapi_clan_500_failure do
  let(:clan_tag) { 'connection-error-clan-tag' }

  around do |e|
    VCR.turned_off do
      stub_request(:any, //).to_return(status: 500)
      e.call
    end
  end
end

RSpec.shared_context :royaleapi_war_log_cassette do
  let(:clan_tag) { 'Y8YU8L08' }

  around do |e|
    VCR.use_cassette('royaleapi/pierwsza_liga/war_log', &e)
  end
end

RSpec.shared_context :royaleapi_war_log_failure_cassette do
  let(:clan_tag) { 'someunknownclantag' }

  around do |e|
    VCR.use_cassette('royaleapi/pierwsza_liga/war_log_failure', &e)
  end
end
