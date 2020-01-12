class War < ApplicationRecord
  belongs_to :clan
  has_many :participations, dependent: :delete_all
end
