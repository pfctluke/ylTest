class Admin::TeamsController < Admin::ApplicationController
  
  before_filter :authenticate_user!
  
  $pageSize = 10
  def individual_list
    @title = "参赛列表"
    item_id = params[:item_id]
    competition_id = params[:competition_id]
    @competition = Competition.find(competition_id)
    @item = @competition.items.where("items.id = ?", item_id).first
    if @item.present?
      @title = @competition.name + "【" + @item.name + "】" + "参赛列表"
      @units = @item.units.paginate(:page => params[:page], :per_page => $pageSize ).order("created_at DESC")
    end
  end
  
  def team_list
    @title = "参赛队伍列表"
    competition_id = params[:competition_id]
    @competition = Competition.find(competition_id)
    if @competition.present?
      @title = "【" + @competition.name + "】" + "参赛队伍列表"
      @teams = Team.where(competition_id: competition_id).paginate(:page => params[:page], :per_page => $pageSize ).order("created_at DESC")
    end
  end
  
  def team_show
    @title = "队伍配置"
    competition_id = params[:competition_id]
    @competition = Competition.find(competition_id)
    @team = Team.find(params[:id])
    if @team.present?
      @title = @competition.name + "【" + @team.name + "队】" + "队伍配置"
      @units = @team.units.paginate(:page => params[:page], :per_page => $pageSize ).order("created_at DESC")
    end
  end

  def destroy
    item_id = params[:item_id]
    @team = Team.find(params[:id])
    if @team.destroy
      flash[:notice] = "删除成功！"
    end
    if @team.competition.kind.to_i == 1
      redirect_to :action => 'individual_list', :item_id => item_id
    else
      redirect_to :action => 'team_list'
    end
  end
end