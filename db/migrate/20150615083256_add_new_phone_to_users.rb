class AddNewPhoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :new_phone, :string
    add_column :users, :change_phone_status, :integer, default: 0 #0未验证旧手机，1已验证旧手机，等待验证新手机
  end
end
