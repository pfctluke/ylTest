class Admin::VenuesController < Admin::ApplicationController
  
  $pageSize = 10
  def index
    @title = "场馆列表"
    @venues = Venue.paginate(:page => params[:page], :per_page => $pageSize ).order("priority DESC", "created_at DESC")
  end
   
  def new
    @title = "添加场馆"
    @venue = Venue.new
  end
  
  def create
    @venue = Venue.new(params[:venue])
    if @venue.save
      redirect_to :action => 'index'
    else
      @title = "添加场馆"
      render "new"
    end
  end
  
  def destroy
    @venue = Venue.find(params[:id])
    @venue.destroy
    redirect_to :action => 'index'
  end
  
  def edit
    @title = "编辑场馆"
    @venue = Venue.find(params[:id])
  end
  
  def update
    @venue = Venue.find(params[:id])
    if @venue.update_attributes(params[:venue])
      redirect_to :action => 'index'
    else
      @title = "编辑场馆"
      render 'edit'
    end
  end

end