class CreateTopicNews < ActiveRecord::Migration
  def change
    create_table :topic_news do |t|
      t.text :title, :null=>false
      t.text :sub_title, :null=>true
      t.text :body, :null=>false
      t.string :source, :null=>true
      t.string :abstract, :null=>false
      t.integer :user_id, :null=>false
      t.integer :topic_id, :null=>false
      t.integer :priority, :null=>false, default: 100
      t.boolean :deleted, default: false

      t.timestamp :created_at, :null=>false
      t.timestamp :updated_at, :null=>false
      t.timestamp :show_time, :null=>false
    end
  end
end
