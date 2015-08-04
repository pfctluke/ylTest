class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :trade_no
      t.string :trade_status_sync
      t.string :trade_status_async
      t.integer :quantity
      t.float :price
      t.float :total_fee
      t.string :subject
      t.integer :user_id
      t.integer :status, default: 0 #0未支付，1支付成功

      t.integer :priority, :null=>false, default: 100
      t.boolean :deleted, default: false
      t.timestamp :created_at, :null=>false
      t.timestamp :updated_at, :null=>false
    end
  end
end
