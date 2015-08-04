class ChangeColumnsSettingsForNews < ActiveRecord::Migration
  def up
    change_column :news, :source, :string, null:true
  end

  def down
    change_column :news, :source, :string, null:false
  end
end
