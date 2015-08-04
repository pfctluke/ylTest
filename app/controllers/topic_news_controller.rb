class TopicNewsController < ApplicationController
  $pageSize = 10
  def index
    @topic = Topic.find(params[:topic_id])
    @topic_news = TopicNews.paginate(:page => params[:page], :per_page => $pageSize ).where(topic_id: params[:topic_id]).order("priority DESC", "show_time DESC")
    if request.headers['X-PJAX']
      render :layout => false
    end
  end

  def show
    @topic = Topic.find(params[:topic_id])
    @topic_news = TopicNews.find(params[:id])
    @images = @topic_news.topic_news_images
    if request.headers['X-PJAX']
      render :layout => false
    end
  end
  
end
