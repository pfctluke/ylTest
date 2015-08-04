class VenuesController < ApplicationController
  
  $pageSize = 12
  def index
    @title = "场馆列表"
    @venues = Venue.paginate(:page => params[:page], :per_page => $pageSize ).order("priority DESC", "created_at DESC")
    if request.headers['X-PJAX']
      render :layout => false
    end
  end
  
  def show
    @venue = Venue.find(params[:id])
    if request.headers['X-PJAX']
      render :layout => false
    end
  end

end