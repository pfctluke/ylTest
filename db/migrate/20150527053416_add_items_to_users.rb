class AddItemsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :status, :integer, default: 2  #0已发送验证码，一般用户，1网协会员待审核， 2网协会员并通过审核， 3网协会员审核拒绝
    add_column :users, :nickname, :string
    add_column :users, :birthday, :timestamp
    add_column :users, :address, :string
    add_column :users, :company, :string
    add_column :users, :club_name, :string
    add_column :users, :tennis_age, :integer
  end
end
