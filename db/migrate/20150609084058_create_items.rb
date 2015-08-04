class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :kind, :null=>false, default: 0 #项目类别，0团体，1个人
      t.integer :rounds, default: 3 #局数，三局两胜或五局三胜
      t.integer :competition_id
      t.integer :priority, :null=>false, default: 100
      t.boolean :deleted, default: false
      t.timestamp :created_at, :null=>false
      t.timestamp :updated_at, :null=>false
    end
  end
end
