class TeamsController < ApplicationController
  
  before_filter :authenticate_user!
  
  $pageSize = 10
  def index
    @teams = Team.joins("join units on teams.id = units.team_id")
    .select("teams.*").uniq
    .where("units.first_player = ? or units.second_player = ?", current_user.id, current_user.id)
    .paginate(:page => params[:page], :per_page => $pageSize ).order("created_at DESC")
    if request.headers['X-PJAX']
      render :layout => false
    end
  end
  
  def show
    @team = Team.find(params[:id])
    @competition = @team.competition
    if request.headers['X-PJAX']
      render :layout => false
    end
  end
  
  def new_individual
    @team = Team.new
    @competition_id = params[:competition_id]
    @competition = Competition.find(@competition_id)
    @item_id = params[:item_id]
    @unit = @team.units.build 
    @unit.item_id = @item_id
    
    if request.headers['X-PJAX']
      render :layout => false
    end
  end
  
  def new_team 
    @team = Team.new
    @competition_id = params[:competition_id]
    @competition = Competition.find(@competition_id)
    @competition.items.each do |item|
      @unit = @team.units.build 
      @unit.item_id = item.id
    end
    
    if request.headers['X-PJAX']
      render :layout => false
    end
  end
  
  def create_individual
    @team = Team.new(params[:team])
    @competition_id = params[:competition_id]
    @team.competition_id = @competition_id
    @team.user_id = current_user.id
    @team.units.first.first_player = current_user.id
    if @team.save
      flash[:notice] = "保存成功！"
      redirect_to :action => 'index'
    else
      render 'new_individual'
    end
  end
  
  def create_team
    @team = Team.new(params[:team])
    @competition_id = params[:competition_id]
    @team.competition_id = @competition_id
    @team.user_id = current_user.id
    if @team.save
      flash[:notice] = "保存成功！"
      redirect_to :action => 'index'
    else
      render 'new_team'
    end
  end

end