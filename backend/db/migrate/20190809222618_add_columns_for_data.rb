class AddColumnsForData < ActiveRecord::Migration[5.2]
  def change
    add_column :clans, :name, :string, null: false

    change_table :memberships, bulk: true do |t|
      t.integer :donated, null: false
      t.integer :received, null: false
      t.string :rank, null: false
    end

    change_table :players, bulk: true do |t|
      t.string :username, null: false
      t.integer :trophies, null: false
      t.integer :level, null: false
    end
  end
end
