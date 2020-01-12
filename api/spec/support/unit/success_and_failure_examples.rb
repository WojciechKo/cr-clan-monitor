RSpec::Matchers.define :be_success do |expectations|
  match do |monad|
    expect(monad.success?).to be(true)
    if expectations
      expect(monad.value!).to match(expectations)
    else
      true
    end
  end
end

RSpec::Matchers.define :be_failure do |expectations|
  match do |monad|
    expect(monad.failure?).to be(true)
    if expectations
      expect(monad.failure).to match(expectations)
    else
      true
    end
  end
end

RSpec.shared_examples :success do
  it 'is Success' do
    expect(subject).to be_success
  end

  it 'matches success' do
    succeed = false
    Operation::Matcher.call(subject) do |m|
      m.success { succeed = true }
      m.failure { raise 'Expected success' }
    end
    expect(succeed).to be(true)
  end
end

RSpec.shared_examples :failure do
  it 'is Failure' do
    expect(subject).to be_failure
  end

  it 'matches failure' do
    failed = false
    Operation::Matcher.call(subject) do |m|
      m.success { raise 'Expected failure' }
      m.failure { failed = true }
    end
    expect(failed).to be(true)
  end
end
