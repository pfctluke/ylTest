class Commodity < ActiveRecord::Base
  attr_accessible :name, :price
  
  validates :price,numericality:{allow_nil: false, greater_than: 0, message: '请输入正确的金额数！'}
   
  def Commodity.get_annual_fee
    Commodity.first.price
  end

  def Commodity.is_number? string
    true if Float(string) rescue false
  end
end
