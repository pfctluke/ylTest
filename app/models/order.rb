class Order < ActiveRecord::Base
  attr_accessible :trade_no, :trade_status_sync, :trade_status_async, :quantity, :price, :total_fee, :subject, :user_id, :status
  # attr_accessible :title, :body
  belongs_to :user
  
  def pay_url
    Alipay::Service.create_direct_pay_by_user_url(
      :out_trade_no      => self.id,
      :price             => self.price,
      :quantity          => self.quantity,
      :subject           => self.subject,
      :logistics_type    => 'DIRECT',
      :logistics_fee     => '0',
      :logistics_payment => 'SELLER_PAY',
      :return_url        => ('http://masstennis.icitymobile.com/orders/' + self.id.to_s),
      :notify_url        => 'http://masstennis.icitymobile.com/orders/notify',
      :receive_name      => 'none', # 这里填写了收货信息，用户就不必填写
      :receive_address   => 'none',
      :receive_zip       => '100000',
      :receive_mobile    => '100000000000'
    )
  end
  
  #只有在未完成状态才标记为完成状态
  def complete
    if self.status == 0
      update_attribute :status, 1
      @user = User.find(self.user_id)
      if @user.present?
        @user.annual_fee_validity = @user.annual_fee_validity + 365 * 24 * 3600
        @user.save
      end
    end
  end
  
  def complete_offline
    if self.status == 0
      update_attribute :status, 2
      @user = User.find(self.user_id)
      if @user.present?
        @user.annual_fee_validity = @user.annual_fee_validity + 365 * 24 * 3600
        @user.save
      end
    end
  end
  
  def show_status
    if self.status == 0
      "未支付"
    elsif self.status == 1
      "已支付"
    else
      "已离线支付"
    end
  end
  
  def show_pay_type
    if self.status > 0
      if self.status == 1
        "在线"
      else
        "离线"
      end
    end
  end
end
