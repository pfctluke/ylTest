class Users::SessionsController < Devise::SessionsController
  after_filter :get_user, :only => [:create]
      
  def create
    #super do |resource|
    #end
    #@user = current_user
    # resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    # sign_in_and_redirect(resource_name, resource)
    phone = params[:user][:phone]
    validCode = params[:user][:valid_code]
    @user = User.where(phone: phone).where("status >= 0").first
    if !phone.blank?
      if !@user.blank?
        if !validCode.blank?
          if (Time.new.to_i - @user.valid_code_create_at.to_i) > (3600 * 24 * 7)#大于7天重新获取
            flash[:notice] ="验证码已过期，请重新获取！"
            redirect_to new_user_session_path and return
          end
          
          if validCode == @user.valid_code
              @user.remember_me = true
              sign_in @user
              flash[:notice] ="登录成功"
              cookies.signed[:user_id] = { :value => @user.id, :expires => 1.year.from_now }
              if current_user.full_name.blank?
                redirect_to  edit_user_registration_path
              else
                if @user.admin?
                  redirect_to admin_users_path
                else
                  respond_with @user, location: after_sign_in_path_for(@user)
                end
              end
          else
            flash[:notice] ="验证码错误"
            redirect_to new_user_session_path
          end
        else
          flash[:notice] ="请填写验证码"
          redirect_to new_user_session_path
        end
      else
        flash[:notice] ="该用户不存在 请先注册"
        redirect_to new_user_session_path
      end
    else
      flash[:notice] ="请输入手机号"
      redirect_to new_user_session_path
    end
    
  end
  
  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    render :update_header
  end
 
  def failure
    logger.debug "------------------------------------------------------------------------------------------log_in_failed"
  end
  
  def get_user
    #render "new"
    logger.debug "------------------------------------------------------------------------------------------get_user!"
  end
  
  def destroy
    cookies.delete :user_id
    super
  end
end