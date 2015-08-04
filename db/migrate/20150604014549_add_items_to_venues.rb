class AddItemsToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :address, :text
    add_column :venues, :lat, :float
    add_column :venues, :lon, :float
    add_column :venues, :phone, :string
  end
end
