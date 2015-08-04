class Admin::CompetitionsController < Admin::ApplicationController
  
  $pageSize = 10
  def index
    @title = "赛事列表"
    @competitions = Competition.paginate(:page => params[:page], :per_page => $pageSize ).order("priority DESC", "created_at DESC")
  end
   
  def new
    @title = "添加赛事"
    @competition = Competition.new
  end
  
  def create
    @competition = Competition.new(params[:competition])
    if @competition.save
      #更新赛事表中的首日比赛日字段
      @first_game_day = @competition.competition_days.order("game_day ASC").first()
      if @first_game_day.present?
        @competition.first_game_day = @first_game_day.game_day
      else
        @competition.first_game_day = nil
      end
      @competition.save
      redirect_to admin_competition_items_path(@competition.id)
    else
      @title = "添加赛事"
      render "new"
    end
  end
  
  def destroy
    @competition = Competition.find(params[:id])
    @competition.destroy
    redirect_to :action => 'index'
  end
  
  def edit
    @title = "编辑赛事"
    @competition = Competition.find(params[:id])
  end
  
  def update
    @competition = Competition.find(params[:id])
    if @competition.update_attributes(params[:competition])
      @first_game_day = @competition.competition_days.order("game_day ASC").first()
      if @first_game_day.present?
        @competition.first_game_day = @first_game_day.game_day
      else
        @competition.first_game_day = nil
      end
      @competition.save
      redirect_to :action => 'index'
    else
      @title = "编辑赛事"
      render 'edit'
    end
  end

  #修改是否显示在首页的状态
  def change_on_home_page_status
    id = params[:competition_id]
    status = params[:status]
    if id.present? && status.present?
      @competition = Competition.find(id)
      @competition.show_on_home_page = status.to_i
      if !@competition.save
        flash[:notice] = "保存失败，请稍后再试！"
      else
        redirect_to admin_competitions_path
      end
    end
  end

end