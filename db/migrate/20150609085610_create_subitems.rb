class CreateSubitems < ActiveRecord::Migration
  def change
    create_table :subitems do |t|
      t.integer :kind, :null=>false #子项目类别，1男单，2女单，3男双，4女双，5混双
      t.integer :item_id
      t.integer :age_limit_type, default: 0 #0无年龄限制，1限制每个选手，2限制双打年龄总和，3限制混双男选手
      t.integer :min_age, default: 0
      t.integer :max_age, default: 100
      t.integer :priority, :null=>false, default: 100
      t.boolean :deleted, default: false
      t.timestamp :created_at, :null=>false
      t.timestamp :updated_at, :null=>false
    end
  end
end
