class AddPathToCarousels < ActiveRecord::Migration
  def change
    add_column :carousels, :path, :string
  end
end
