class AddUniqueIndexToMemberships < ActiveRecord::Migration[5.2]
  def change
    add_index(:memberships, [:player_id, :clan_id], unique: true)
  end
end
