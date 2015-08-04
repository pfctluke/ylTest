#参加比赛的小队，由若干作战单元（units）构成
class Team < ActiveRecord::Base
  attr_accessible :name, :competition_id, :units_attributes
  
  has_many :units, :dependent => :destroy
  belongs_to :competition
  
  accepts_nested_attributes_for :units, :allow_destroy => true
  
  validate :valid_team_name?
  
  def valid_team_name?
    if self.name.blank? && self.competition.kind.to_i == 0
      errors.add(:from_team_name, "团队赛需要输入队伍名称！")
    end
  end

end
