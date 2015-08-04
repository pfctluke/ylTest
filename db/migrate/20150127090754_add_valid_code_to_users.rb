class AddValidCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :users, :valid_code, :string
    add_column :users, :valid_code_create_at, :datetime
  end
end
