class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.text :image_string, :null=>false
      t.integer :news_id, :null=>false
      t.string :photo_file_name, :null=>false
      t.string :photo_content_type, :null=>false
      t.string :photo_file_size, :null=>false
      t.string :photo_updated_at, :null=>false

      t.boolean :deleted, default: false
      t.integer :order_priority, :null=>false, default: 100

      t.timestamp :created_at, :null=>false
      t.timestamp :updated_at, :null=>false
    end
  end
end
