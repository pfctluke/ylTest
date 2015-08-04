class Admin::TopicNewsController < Admin::ApplicationController
  
  $pageSize = 10
  def index
    @topic_id = params[:topic_id]
    @topic = Topic.find(params[:topic_id])
    @title = "新闻列表"
    if @topic.present?
      @title = @topic.title + "新闻列表"
    end
    @topic_news = TopicNews.paginate(:page => params[:page], :per_page => $pageSize ).where(topic_id: params[:topic_id]).order("priority DESC", "created_at DESC")
  end
   
  def new
    @topic_id = params[:topic_id]
    @title = "添加新闻"
    @topic_news = TopicNews.new
  end
  
  def create
    @topic = Topic.find(params[:topic_id])
    #@topic_news = @topic.topic_news.create(params[:topic_news])
    @topic_news = TopicNews.new(params[:topic_news])
    @user = current_user
    @topic_news.user_id = @user.id
    @topic_news.topic_id = params[:topic_id]
    if @topic_news.save
      redirect_to admin_topic_topic_news_index_path
    else
      @title = "添加新闻"
      render "new"
    end
  end
  
  def destroy
    @topic_news = TopicNews.find(params[:id])
    @topic_news.destroy
    redirect_to admin_topic_topic_news_index_path
  end
  
  def edit
    @topic_id = params[:topic_id]
    @title = "编辑新闻"
    @topic_news = TopicNews.find(params[:id])
  end
  
  def update
    @topic_id = params[:topic_id]
    @topic_news = TopicNews.find(params[:id])
    if @topic_news.update_attributes(params[:topic_news])
      redirect_to admin_topic_topic_news_index_path(@topic_news.topic_id)
    else
      @title = "编辑新闻"
      render 'edit'
    end
  end

end