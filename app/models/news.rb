class News < ActiveRecord::Base
  
  attr_accessible :id, :title, :sub_title, :body, 
                  :source, :abstract, :user_id, :priority, 
                   :deleted, :created_at, :updated_at, :show_time, :images , :images_attributes
                   
  has_many :images, :dependent => :destroy
  accepts_nested_attributes_for :images, :reject_if => lambda { |a| a[:photo].blank? }, :allow_destroy => true
 
  validates_presence_of :title, :message =>"请输入新闻的标题！"
  #validates_presence_of :sub_title, :message =>"请输入新闻的副标题"
  # validates_presence_of :source, :message =>"请输入新闻的来源！"ence_of :show_time, :message =>"请输入新闻的日期！"
  validates_presence_of :title, :message =>"请输入新闻的标题！"
  validates_presence_of :abstract, :message =>"请输入新闻的摘要！"
  validates_presence_of :body, :message =>"请输入新闻的正文！"
  
  validates_length_of :title, :maximum => 255,:message=>"标题长度不能超过255个字！"
  validates_length_of :sub_title, :maximum => 255,:message=>"副标题长度不能超过255个字！"
  validates_length_of :source, :maximum => 255,:message=>"来源长度不能超过255个字！"
  validates_length_of :abstract, :maximum => 255,:message=>"摘要长度不能超过255个字！"
    
  def show_body
    if self.abstract.size > 20#由于正文是富文本 改为截取摘要
      self.abstract[0,20]<<"..."
    else
      self.abstract
    end
  end
  
  def show_news_time
    if self.show_time.present?
      self.show_time.strftime('%F')
    else
      ''
    end
  end
  
end