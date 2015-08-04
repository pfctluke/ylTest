class Subitem < ActiveRecord::Base
  attr_accessible :title, :game_day, :item_id
  
  belongs_to :item
  
  validates_presence_of :title, :message =>"请输入比赛标题！"
  
  def show_info
    @info = self.title
    if self.game_day.blank?
      @info = @info + "（待定）"
    else
      @info = @info + self.game_day.strftime("（%Y年%m月%d日）")
    end
  end
end
