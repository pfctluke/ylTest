class AddItemsToClubs < ActiveRecord::Migration
  def change
    add_column :clubs, :introduction, :text
    add_column :clubs, :field, :text
    add_column :clubs, :membership, :text
    add_column :clubs, :phone, :string
    add_column :clubs, :status, :integer, default: 2  #1已注册待审核， 2注册并通过审核， 3审核拒绝
  end
end
