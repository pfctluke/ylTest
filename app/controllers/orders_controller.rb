class OrdersController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:notify]
  
  $pageSize = 10
  def index
    @user = current_user
    if @user.status != 2
      redirect_to root_path
    end
    @orders = current_user.orders.where(deleted: false).where("status > 0").paginate(:page => params[:page], :per_page => $pageSize ).order("priority DESC", "created_at DESC")
  end
  
  def new
    @order = Order.new
    @user = current_user
    if @user.status != 2
      redirect_to root_path
    end
    @expire_time = current_user.annual_fee_validity + 365 * 24 * 3600
    if @expire_time.present?
      @expire_time = @expire_time.strftime('%F %R')
    end
    if request.headers['X-PJAX']
      render :layout => false
    end
  end
  
  def create
    @order = Order.new(params[:order])
    @order.quantity = 1
    @order.price = Commodity.get_annual_fee
    @order.total_fee = Commodity.get_annual_fee
    @order.subject = "会员年费"
    @order.user_id = current_user.id
    
    if @order.save
      redirect_to @order.pay_url
    else
      render "new"
    end
  end
  
  # 用户支付完毕后，重定向回来的页面
  def show
    @order = current_user.orders.find params[:id]

    # 友好的提示当前订单的状态
    callback_params = params.except(*request.path_parameters.keys)
    if callback_params.any? && Alipay::Sign.verify?(callback_params)
      if params[:trade_no].present? && params[:trade_no].length > 0
        @order.update_attribute :trade_no, params[:trade_no]
      end
      
      case params[:trade_status]
      when 'TRADE_SUCCESS'
        @message = '支付成功！'
        @order.update_attributes(trade_status_sync: "TRADE_SUCCESS")
        @order.complete
      when 'TRADE_FINISHED'
        @message = '交易已结束！'
        @order.update_attributes(trade_status_sync: "TRADE_FINISHED")
        @order.complete
      end
    end
  end

  # 支付宝异步消息接口
  def notify
    notify_params = params.except(*request.path_parameters.keys)
    # 先校验消息的真实性
    if Alipay::Sign.verify?(notify_params) && Alipay::Notify.verify?(notify_params)
      # 获取交易关联的订单
      @order = Order.find params[:out_trade_no]
      @order.update_attribute :trade_no, params[:trade_no]

      case params[:trade_status]
      when 'TRADE_SUCCESS'
        @order.update_attributes(trade_status_async: "TRADE_SUCCESS")
        @order.complete
      when 'TRADE_FINISHED'
        @order.update_attributes(trade_status_async: "TRADE_FINISHED")
        @order.complete
      end

      render :text => 'success' # 成功接收消息后，需要返回纯文本的 ‘success’，否则支付宝会定时重发消息，最多重试7次。 
    else
      render :text => 'error'
    end
  end
end