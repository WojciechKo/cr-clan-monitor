FactoryBot.define do
  factory :clan do
    tag { SecureRandom.base64(6) }
    sequence :name do |n|
      "Clan - #{n}"
    end
  end
end
