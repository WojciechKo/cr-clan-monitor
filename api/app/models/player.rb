class Player < ApplicationRecord
  has_one :membership, dependent: :delete
end
