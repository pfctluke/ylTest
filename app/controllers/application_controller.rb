class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  
  before_filter :check_login
 
  private
 
  def record_not_found
    redirect_to root_url
  end
  
  def check_login
    unless user_signed_in?
      @user_id = cookies.signed[:user_id]
      if @user_id.present? && numeric?(@user_id)
        @user = User.where('id' => @user_id.to_i).where('status' => 2).first
        if @user.present?
          sign_in @user
        end
      end
    end
  end
  
  def numeric?(string)
    !!Kernel.Float(string) 
    rescue TypeError, ArgumentError
    false
  end
end
