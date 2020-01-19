class Participation < ApplicationRecord
  belongs_to :membership
  belongs_to :war
end
