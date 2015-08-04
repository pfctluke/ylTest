class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.integer :first_player
      t.integer :second_player
      t.integer :team_id
      t.integer :item_id
      t.timestamps
    end
  end
end
