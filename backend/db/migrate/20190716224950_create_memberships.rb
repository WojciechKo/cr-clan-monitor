class CreateMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :memberships do |t|
      t.references :player, foreign_key: true, index: true
      t.references :clan, foreign_key: true, index: true

      t.timestamps
    end
  end
end
