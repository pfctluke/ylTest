class AddShowTimeToNews < ActiveRecord::Migration
  def change
    add_column :news, :show_time, :timestamp
  end
end
