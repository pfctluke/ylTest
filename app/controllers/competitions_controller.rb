class CompetitionsController < ApplicationController
  
  $pageSize = 12
  def index
    @competitions = Competition.paginate(:page => params[:page], :per_page => $pageSize ).order("created_at DESC")
    if request.headers['X-PJAX']
      render :layout => false
    end
  end

  def show
    @competition = Competition.find(params[:id])
    if request.headers['X-PJAX']
      render :layout => false
    end
  end
end