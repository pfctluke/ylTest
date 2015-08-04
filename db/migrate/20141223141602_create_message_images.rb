class CreateMessageImages < ActiveRecord::Migration
  def change
    create_table :message_images do |t|
      t.integer :message_id
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
