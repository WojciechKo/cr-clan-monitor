module ResponseHelpers
  def not_found_response
    match(
      'error' => 'not_found',
      'message' => 'Not found'
    )
  end

  def clan_response
    match(
      'tag' => be_a(String),
      'name' => be_a(String),
      'members' => all(
        match(
          'tag' => be_a(String),
          'username' => be_a(String),
          'trophies' => be_a(Integer),
          'level' => be_a(Integer),
          'donated' => be_a(Integer),
          'received' => be_a(Integer),
          'rank' => be_a(String),
          'war_participation' => match_array([])
        )
      )
    )
  end
end

RSpec.configure do |config|
  config.include ResponseHelpers
end

