class Admin::ItemsController < Admin::ApplicationController
  
  $pageSize = 10
  def index
    @competition_id = params[:competition_id]
    @competition = Competition.find(params[:competition_id])
    @title = "项目列表"
    if @competition.present?
      @title = @competition.name + "项目列表"
    end
    @items = Item.paginate(:page => params[:page], :per_page => $pageSize ).where(competition_id: params[:competition_id]).order("priority DESC", "created_at DESC")
  end
   
  def new
    @competition_id = params[:competition_id]
    @title = "添加项目"
    @item = Item.new
  end
  
  def create
    @competition = Competition.find(params[:competition_id])
    @competition_id = params[:competition_id]
    @item = Item.new(params[:item])
    @item.competition_id = @competition_id
    if @item.save
      redirect_to :action => 'index'
    else
      @title = "添加项目"
      render "new", :kind => @kind, :rounds => @rounds
    end
  end
  
  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to :action => 'index'
  end
  
  def edit
    @competition_id = params[:competition_id]
    @title = "编辑项目"
    @item = Item.find(params[:id])
  end
  
  def update
    @item = Item.find(params[:id])
    @competition_id = params[:competition_id]
    if @item.update_attributes(params[:item])
      redirect_to :action => 'index'
    else
      @title = "编辑项目"
      render 'edit'
    end
  end

end