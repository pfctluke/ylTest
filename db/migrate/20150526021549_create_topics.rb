class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.text :title, :null=>false
      t.integer :user_id, :null=>false
      t.integer :priority, default: 100
      t.boolean :deleted, default: false
      
      t.timestamp :created_at, :null=>false
      t.timestamp :updated_at, :null=>false
    end
  end
end
