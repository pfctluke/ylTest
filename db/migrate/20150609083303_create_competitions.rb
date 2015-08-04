class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.string :name, :null=>false
      t.timestamp :start_time, :null=>false
      t.timestamp :end_time, :null=>false
      t.string :address, :null=>false
      t.text :rule, :null=>false
      t.integer :priority, :null=>false, default: 100
      t.boolean :deleted, default: false
      t.timestamp :created_at, :null=>false
      t.timestamp :updated_at, :null=>false
    end
  end
end
