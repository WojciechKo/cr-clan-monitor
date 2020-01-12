class Membership < ApplicationRecord
  belongs_to :clan
  belongs_to :player

  has_many :participations, dependent: :delete_all
end
