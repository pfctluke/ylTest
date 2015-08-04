class Topic < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :id, :title, :user_id, :priority, :deleted, :created_at, :updated_at
  
  has_many :topic_news
  
  validates_presence_of :title, :message =>"请输入专题的标题！"
  validates_length_of :title, :maximum => 255,:message=>"标题长度不能超过255个字！"
end
