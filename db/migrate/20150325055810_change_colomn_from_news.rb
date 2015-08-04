class ChangeColomnFromNews < ActiveRecord::Migration
  def up
    change_column :news, :sub_title, :string, null:true
  end

  def down
    change_column :news, :sub_title, :string, null:false
  end
end
