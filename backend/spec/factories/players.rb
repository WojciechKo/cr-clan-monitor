FactoryBot.define do
  factory :player do
    tag { SecureRandom.base64(6) }

    sequence :username do |n|
      "Player - #{n}"
    end
    level { rand(1..13) }
    trophies { rand(1..5000) }

    transient do
      clan { nil }
    end

    after(:create) do |player, evaluator|
      create(:membership, clan: evaluator.clan, player: player) if evaluator.clan
    end
  end
end
