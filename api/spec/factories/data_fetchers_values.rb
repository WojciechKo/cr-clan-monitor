FactoryBot.define do
  initialize_with { new(**attributes) }

  factory :clan_info_value, class: DataFetchers::Values::ClanInfo do
    name    { 'Pierwsza liga' }
    tag     { SecureRandom.base64(6) }
    members { [] }
  end

  factory :clan_member_value, class: DataFetchers::Values::ClanMember do
    tag { SecureRandom.base64(6) }
    sequence :username do |n|
      "Player - #{n}"
    end
    last_seen { (Time.current - 13.hours).utc.to_s }
    rank { :member }
    trophies { 4501 }
    level { 12 }
    donated { 41 }
    received { 51 }
  end
end
