class CreateParticipations < ActiveRecord::Migration[5.2]
  def change
    create_table :participations do |t|
      t.references :membership, foreign_key: true, index: true
      t.references :war, foreign_key: true, index: true

      t.integer :cards_collected
      t.string :collection_day_battles, array: true
      t.string :war_day_battles, array: true

      t.timestamps
    end
  end
end
