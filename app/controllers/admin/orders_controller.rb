class Admin::OrdersController < Admin::ApplicationController
   
  $pageSize = 10
  def index
    @title = "缴费列表"
    @orders = Order.where(deleted: false).paginate(:page => params[:page], :per_page => $pageSize ).order("priority DESC", "created_at DESC")
  end
  
  def new
    @title = "添加离线支付"
    @order = Order.new
    @user = User.find(params[:user_id])
    @order.total_fee = Commodity.get_annual_fee
    @order.subject = "会员年费"
    @expire_time = current_user.annual_fee_validity + 365 * 24 * 3600
    if @expire_time.present?
      @expire_time = @expire_time.strftime('%F %R')
    end
    if request.headers['X-PJAX']
      render :layout => false
    end
  end
  
  def create
    @title = "添加离线支付"
    @order = Order.new(params[:order])
    @user = User.find(params[:user_id])
    @order.quantity = 1
    @order.price = Commodity.get_annual_fee
    @order.total_fee = Commodity.get_annual_fee
    @order.subject = "会员年费"
    @order.user_id = @user.id
    
    if @order.save
      @order.complete_offline
      redirect_to admin_users_path
    else
      redirect_to :action => 'new', :user_id => params[:user_id]
    end
  end
  
  # 用户支付完毕后，重定向回来的页面
  def show
    @title = "查看缴费详情"
    @order = Order.find(params[:id])
  end
  
  def destroy
    @order = Order.find(params[:id])
    if @order.present?
      @order.deleted = true
      if @order.save
        flash[:notice] = "删除成功！"
      else
        flash[:error] = "删除失败！"
      end
      redirect_to :action => 'index'
    end
  end

  def change_annual_fee
    annual_fee = params[:annual_fee]
    if !Commodity.is_number?(annual_fee) || annual_fee.blank?
      flash[:error] = "请输入正确的金额数！"
      redirect_to :action => 'index' and return
    end

    @commodity = Commodity.first
    @commodity.price = annual_fee
    if @commodity.save
      flash[:notice] = "修改成功！"
    else
      flash[:error] = "修改失败！"
    end
    redirect_to :action => 'index'
  end
end