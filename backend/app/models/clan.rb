class Clan < ApplicationRecord
  has_many :memberships, dependent: :delete_all
  has_many :wars, dependent: :delete_all
end
