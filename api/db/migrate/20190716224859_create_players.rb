class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :tag

      t.timestamps
    end

    add_index :players, :tag, unique: true
  end
end
