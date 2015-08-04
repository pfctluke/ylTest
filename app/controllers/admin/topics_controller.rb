class Admin::TopicsController < Admin::ApplicationController
  
  $pageSize = 10
  def index
    @title = "专题列表"
    @topics = Topic.paginate(:page => params[:page], :per_page => $pageSize ).order("priority DESC", "created_at DESC")
  end
   
  def new
    @title = "添加专题"
    @topic = Topic.new
  end
  
  def create
    @topic = Topic.new(params[:topic])
    @user = current_user
    @topic.user_id = @user.id
    if @topic.save
      redirect_to :action => 'index'
    else
      @title = "添加专题"
      render "new"
    end
  end
  
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    redirect_to :action => 'index'
  end
  
  def edit
    @title = "编辑专题"
    @topic = Topic.find(params[:id])
  end
  
  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(params[:topic])
      redirect_to :action => 'index'
    else
      @title = "编辑专题"
      render 'edit'
    end
  end

end