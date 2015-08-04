class AddPersonalSignatureToUsers < ActiveRecord::Migration
  def change
    add_column :users, :personal_signature, :string
    add_column :users, :sex ,:integer, null: false, default: 0
  end
end