class RemoveAnnualFeeFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :annual_fee
  end
end
