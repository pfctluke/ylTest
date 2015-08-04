class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name 
      t.integer :competition_id
      t.integer :user_id
      t.timestamps
    end
  end
end
