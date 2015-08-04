class Admin::NewsController < Admin::ApplicationController
  
  $pageSize = 10
  def index
    @title = "新闻列表"
    @news = News.paginate(:page => params[:page], :per_page => $pageSize ).order("priority DESC", "created_at DESC")
  end
   
  def new
    @title = "添加新闻"
    @news = News.new
  end
  
  def create
    @news = News.new(params[:news])
    @user = current_user
    @news.user_id = @user.id
    if @news.save
      redirect_to admin_news_index_path
    else
      @title = "添加新闻"
      render "new"
    end
  end
  
  def destroy
    @news = News.find(params[:id])
    @news.destroy
    redirect_to admin_news_index_path
  end
  
  def edit
    @title = "编辑新闻"
    @news = News.find(params[:id])
  end
  
  def update
    @news = News.find(params[:id])
    if @news.update_attributes(params[:news])
      redirect_to admin_news_index_path
    else
      @title = "编辑新闻"
      render 'edit'
    end
  end

end