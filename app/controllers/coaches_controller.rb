class CoachesController < ApplicationController
  
  $pageSize = 12
  def index
    @users = User.where('status' => 2).where('is_coach' => true).paginate(:page => params[:page], :per_page => $pageSize ).order("created_at DESC")
    if request.headers['X-PJAX']
      render :layout => false
    end
  end

end