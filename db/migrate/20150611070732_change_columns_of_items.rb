class ChangeColumnsOfItems < ActiveRecord::Migration
  def change
    remove_column :items, :rounds
    add_column :items, :name, :string
    add_column :items, :remark, :string
  end
end
