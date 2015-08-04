class Admin::CarouselsController < Admin::ApplicationController
  
  $pageSize = 10
  def index
    @title = "头图列表"
    @carousels = Carousel.paginate(:page => params[:page], :per_page => $pageSize ).order("priority DESC", "created_at DESC")
  end
  
  def new
    @title = "添加头图"
    @carousel = Carousel.new
  end
  
  def create
    @carousel = Carousel.new(params[:carousel])
    if @carousel.save
      redirect_to admin_carousels_path
    else
      @title = "添加头图"
      render "new"
    end
  end
  
  def edit
    @title = "编辑头图"
    @carousel = Carousel.find(params[:id])
  end
  
  def update
    @carousel = Carousel.find(params[:id])
    if @carousel.update_attributes(params[:carousel])
      redirect_to admin_carousels_path
    else
      @title = "编辑头图"
      render 'edit'
    end
  end
  
  def destroy
    @carousel = Carousel.find(params[:id])
    @carousel.destroy
    redirect_to admin_carousels_path
  end

end