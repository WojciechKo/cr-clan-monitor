FactoryBot.define do
  factory :war do
    started_at { Time.current }
    finished { false }
  end
end
