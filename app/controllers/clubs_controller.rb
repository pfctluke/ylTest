class ClubsController < ApplicationController
  before_filter :authenticate_user!, only:[:create, :edit, :update]
  
  $pageSize = 12
  def index
    @clubs = Club.paginate(:page => params[:page], :per_page => $pageSize ).order("priority DESC", "created_at DESC")
  end
  
  def new
    @club = Club.new
    if user_signed_in?
      @user = current_user
      if @user.status != 2  #不是通过审核的网协会员不予注册俱乐部
        flash[:notice] ="只有园区网协会员才可进行俱乐部注册，请先申请成为网协会员！"
        redirect_to users_register_path
      end
    else
      flash[:notice] ="只有园区网协会员才可进行俱乐部注册，如果您已注册成为园区网协会员，请先登录！"
      redirect_to new_user_session_path
    end
    
    if request.headers['X-PJAX']
      render :layout => false
    end
  end
  
  def create
    @club = Club.new(params[:club])
    @club.status = 1
    @user = current_user
    @club_user_relationship = ClubUserRelationship.new
    if @club.save
      @club_user_relationship.club_id = @club.id
      @club_user_relationship.user_id = @user.id
      @club_user_relationship.permission = 0
      if @club_user_relationship.save
        redirect_to :action => "result"
      end
    else
      render "new"
    end
  end
  
  def edit
    @club = Club.find(params[:id])
    if request.headers['X-PJAX']
      render :layout => false
    end
  end
  
  def update
    @club = Club.find(params[:id])
    if @club.update_attributes(params[:club])
      redirect_to edit_club
    else
      render 'edit'
    end
  end

  def show
    @club = Club.find(params[:id])
    @user = @club.users.where('club_user_relationships.permission' => 0).first
    if request.headers['X-PJAX']
      render :layout => false
    end
  end
  
  def result
    
  end
end
