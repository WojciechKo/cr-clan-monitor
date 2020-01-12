FactoryBot.define do
  factory :membership do
    player
    clan

    donated { rand(0..1500) }
    received { rand(0..1000) }
    rank { 'member' }

    trait :elder do
      rank { 'elder' }
    end
  end
end
