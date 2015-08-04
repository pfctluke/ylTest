class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      
      t.integer :user_id
      t.string :body, default: ''
      t.integer :priority, default: 100
      t.boolean :deleted, default: false

      t.timestamp :created_at, :null=>false
      t.timestamp :updated_at, :null=>false
    end
  end
end
