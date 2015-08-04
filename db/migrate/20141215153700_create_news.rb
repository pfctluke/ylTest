class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.text :title, :null=>false
      t.text :sub_title, :null=>false
      t.string :author, :null=>false
      t.text :body, :null=>false
      t.string :source, :null=>false
      t.string :abstract, :null=>false
      t.integer :user_id, :null=>false
      t.integer :priority, :null=>false, default: 100
      t.boolean :image_exists, default: false
      t.boolean :deleted, default: false

      t.timestamp :created_at, :null=>false
      t.timestamp :updated_at, :null=>false
    end
  end
end
