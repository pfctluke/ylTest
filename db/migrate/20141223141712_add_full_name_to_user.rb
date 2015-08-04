class AddFullNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :full_name, :string
    add_column :users, :club_id, :integer
  end
end
