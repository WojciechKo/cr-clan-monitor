class CreateClans < ActiveRecord::Migration[5.2]
  def change
    create_table :clans do |t|
      t.string :tag

      t.timestamps
    end

    add_index :clans, :tag, unique: true
  end
end
