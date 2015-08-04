class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :name, default: ''
      t.string :logo_file_name
      t.string :logo_content_type
      t.string :logo_file_size
      t.string :logo_updated_at
      t.integer :priority, default: 100
      t.boolean :deleted, default: false

      t.timestamp :created_at, :null=>false
      t.timestamp :updated_at, :null=>false
    end
  end
end
