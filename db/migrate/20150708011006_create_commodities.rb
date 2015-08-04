class CreateCommodities < ActiveRecord::Migration
  def change
    create_table :commodities do |t|
      t.string :name
      t.float :price
      t.timestamps
    end
    
    Commodity.create :name => "会员年费", :price => 20
  end
end
