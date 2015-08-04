class RemoveColumnFromNews < ActiveRecord::Migration
  def up
    remove_column :news, :author
    remove_column :news, :image_exists
  end

  def down
    add_column :news, :image_exists, :boolean
    add_column :news, :author, :string
  end
end
