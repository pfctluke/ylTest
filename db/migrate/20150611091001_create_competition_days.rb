class CreateCompetitionDays < ActiveRecord::Migration
  def change
    create_table :competition_days do |t|
      t.string :title
      t.timestamp :game_day
      t.integer :competition_id
      t.integer :priority, :null=>false, default: 100
      t.boolean :deleted, default: false
      t.timestamp :created_at, :null=>false
      t.timestamp :updated_at, :null=>false
    end
  end
end
