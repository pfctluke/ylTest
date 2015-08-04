class CreateVenueImages < ActiveRecord::Migration
  def change
    create_table :venue_images do |t|
      t.text :image_string, :null=>false
      t.integer :venue_id
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.string :image_updated_at
      t.integer :priority, default: 100
      t.boolean :deleted, default: false

      t.timestamp :created_at, :null=>false
      t.timestamp :updated_at, :null=>false
    end
  end
end
