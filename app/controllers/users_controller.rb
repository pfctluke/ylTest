class UsersController < ApplicationController
  before_filter :authenticate_user!, only:[:index, :edit, :update, :change_phone, :verify_new_phone]
  def index
  end

  def register
    @user = current_user
    if @user.blank?
      @user = User.new
    end
    if request.headers['X-PJAX']
      render :layout => false
    end
  end
  
  def normal_register
    @user = current_user
    if @user.blank?
      @user = User.new
    else
      redirect_to root_path
    end
    if request.headers['X-PJAX']
      render :layout => false
    end
  end

  def create
    phone = params[:user][:phone]
    validCode = params[:user][:valid_code]
    @user = User.where(phone: phone).where("status > 0").first
    if !@user.blank?  #如果该用户已经申请过网协会员
      if @user.status == 1
        flash[:notice] ="该用户正在接受审核"
      elsif @user.status == 2
        flash[:notice] ="该用户已经是网协会员"
      elsif @user.status == 3
        flash[:notice] ="该用户审核被拒绝"
      end
      render "register"
    else
      @user = User.find_by_phone(phone)
      if @user.present? #已经获取验证码
        if @user.status == 0 && !user_signed_in?
          flash[:notice] ="该账户已存在，请登录后再进行申请会员操作"
          render "register" and return
        end
        if (Time.new.to_i - @user.valid_code_create_at.to_i) > (3600 * 24 * 7)#大于7天重新获取
          flash[:notice] ="验证码已过期，请重新获取！"
          render "register"
        elsif validCode == @user.valid_code
          params[:user][:status] = 1
          if @user.profile_picture_file_name.blank? && params[:user][:profile_picture].blank?
            flash[:notice] ="请上传头像图片！"
            render "register"
          elsif @user.update_attributes(params[:user])
            redirect_to :action => "result"
          end
        else
          flash[:notice] ="验证码错误"
          render "register"
        end 
      else
        @user = User.new
        flash[:notice] ="请先获取验证码！"
        render "register"
      end
    end
  end
  
  def normal_create
    phone = params[:user][:phone]
    validCode = params[:user][:valid_code]
    @user = User.find_by_phone(phone)
    if @user.present? #已经获取验证码
      if @user.status >= 0 && !user_signed_in?
        flash[:notice] ="该账户已存在，请直接登录！"
        render "normal_register" and return
      end
      if (Time.new.to_i - @user.valid_code_create_at.to_i) > (3600 * 24 * 7)#大于7天重新获取
        flash[:notice] ="验证码已过期，请重新获取！"
        render "normal_register"
      elsif validCode == @user.valid_code
        params[:user][:status] = 0
        if @user.update_attributes(params[:user])
          @user.remember_me = true
          sign_in @user
          cookies.signed[:user_id] = { :value => @user.id, :expires => 1.year.from_now }
          redirect_to root_path
        end
      else
        flash[:notice] ="验证码错误"
        render "normal_register"
      end 
    else
      @user = User.new
      flash[:notice] ="请先获取验证码！"
      render "normal_register"
    end
  end

  def edit
    if user_signed_in?
      @user = current_user
      if request.headers['X-PJAX']
        render :layout => false
      end
    end
  end

  def update
    @user = current_user
    if !@user.blank?
      if @user.update_attributes(params[:user])
        flash[:notice] = "更新成功！"
        redirect_to edit_user_registration_path
      # render :json => {"msg" => "success"}.to_json
      else
      # flash[:notice] = "更新失败！"
        render edit_user_registration_path
      # render :json => {"msg" => "failed"}.to_json
      end
    else
      redirect_to new_user_session_path
    end
  end
  
  def change_phone
    @user = current_user
  end
  
  def check_old_phone
    @user = current_user
    !validCode = params[:user][:valid_code]
    if !validCode.blank?
      if (Time.new.to_i - @user.valid_code_create_at.to_i) > (3600 * 24 * 7)#大于7天重新获取
        flash[:notice] ="验证码已过期，请重新获取！"
        redirect_to users_change_phone_path and return
      end

      if validCode == @user.valid_code
        @user.change_phone_status = 1
        @user.valid_code = ""
        if @user.save
          redirect_to users_verify_new_phone_path
        end
      else
        flash[:notice] ="验证码错误"
        redirect_to users_change_phone_path
      end
    else
      flash[:notice] ="请填写验证码"
      redirect_to users_change_phone_path
    end
  end
  
  def verify_new_phone
    @user = current_user
    if @user.change_phone_status == 0
      flash[:notice] ="请先验证原手机"
      redirect_to users_change_phone_path
    end
  end
  
  def update_phone
    @user = current_user
    !validCode = params[:user][:valid_code]
    if !validCode.blank?
      if (Time.new.to_i - @user.valid_code_create_at.to_i) > (3600 * 24 * 7)#大于7天重新获取
        flash[:notice] ="验证码已过期，请重新获取！"
        redirect_to users_verify_new_phone_path and return
      end
      
      @old_user = User.find_by_phone(@user.new_phone)
      if @old_user.present?
        flash[:notice] ="该手机号已存在！"
        redirect_to users_verify_new_phone_path and return
      end

      if validCode == @user.valid_code
        @user.phone = @user.new_phone
        @user.new_phone = ""
        @user.change_phone_status = 0
        if @user.save
          sign_out @user
          cookies.delete :user_id
          flash[:notice] ="修改成功，请使用新手机号登陆"
          redirect_to new_user_session_path
        end
      else
        flash[:notice] ="验证码错误"
        redirect_to users_verify_new_phone_path
      end
    else
      flash[:notice] ="请填写验证码"
      redirect_to users_verify_new_phone_path
    end
  end

# private
# def user_params
# params.require(:article).permit(:title, :text)
# end

  def search_users
    @search_content = params[:search_content]
    users = User.where("status >= 0").where("lower(users.full_name) LIKE lower(?)", '%' + @search_content + '%').first(10)
    render :json => users.to_json(:only => [:id, :full_name, :phone])
  end

end
