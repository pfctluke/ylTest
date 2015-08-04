class Admin::MessagesController < Admin::ApplicationController

  $pageSize = 10
  def index
    @title = "帖子列表"
    @messages = Message.paginate(:page => params[:page], :per_page => $pageSize ).where("deleted = ?",false).order("priority DESC", "created_at DESC")
  end
  
  def show
    @title = "帖子详情"
    @message = Message.find(params[:id])
  end
  
  def edit
    
  end

  def update
    
  end

  def destroy
    @message = Message.find(params[:id])
    @message.deleted = true
    @message.save
    # @message.destroy
    redirect_to admin_messages_path
  end

end