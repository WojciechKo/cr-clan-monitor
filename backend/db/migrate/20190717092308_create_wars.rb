class CreateWars < ActiveRecord::Migration[5.2]
  def change
    create_table :wars do |t|
      t.references :clan, foreign_key: true, index: true
      t.timestamp :started_at, nil: false
      t.boolean :finished, nil: false

      t.timestamps
    end

    add_index :wars, :started_at
    add_index :wars, :finished
  end
end
