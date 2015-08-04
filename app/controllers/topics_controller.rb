class TopicsController < ApplicationController
  $pageSize = 10
  def index
    @topics = Topic.paginate(:page => params[:page], :per_page => $pageSize ).order("priority DESC", "created_at DESC")
    if request.headers['X-PJAX']
      render :layout => false
    end
  end
  
end