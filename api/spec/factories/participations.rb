FactoryBot.define do
  factory :participation do
    membership
    war
    cards_collected { 150 }
    collection_day_battles { ['victory', 'defeat', 'draw'] }
    war_day_battles { ['victory'] }
  end
end
