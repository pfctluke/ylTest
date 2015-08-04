class AddPayItemsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :approval_time, :timestamp
    add_column :users, :annual_fee, :float, default: 20
    add_column :users, :annual_fee_validity, :timestamp
    execute "update users set approval_time = now()"
    execute "update users set annual_fee_validity = now()"
  end
end
