class NewsController < ApplicationController
  $pageSize = 10
  def index
    @news = News.paginate(:page => params[:page], :per_page => $pageSize ).order("priority DESC", "show_time DESC")
    if request.headers['X-PJAX']
      render :layout => false
    end
  end

  def show
    @news = News.find(params[:id])
    @images = @news.images
    if request.headers['X-PJAX']
      render :layout => false
    end
  end
  
end
