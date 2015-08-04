class CreateTopicNewsImages < ActiveRecord::Migration
  def change
    create_table :topic_news_images do |t|
      t.text :image_string, :null=>false
      t.integer :topic_news_id
      t.string :image_file_name
      t.string :image_content_type
      t.string :image_file_size
      t.string :image_updated_at
      t.integer :priority, default: 100
      t.boolean :deleted, default: false

      t.timestamp :created_at, :null=>false
      t.timestamp :updated_at, :null=>false
    end
  end
end
