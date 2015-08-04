class Message < ActiveRecord::Base
  
  attr_accessible :id, :body, :deleted, :message_images_attributes
  belongs_to :user
  has_many :message_images, :dependent => :destroy
  
  accepts_nested_attributes_for :message_images
  
  validates_presence_of :body, :message =>"请输入您要发布的内容！"
  validates_length_of :body, :maximum => 255,:message=>"内容不能超过255个字！"
   
  def create_time_show
    diff = Time.current - created_at
    day = diff.to_i / 86400
    free = diff % 86400
    if day > 0
      day.to_i.to_s << "天前"
    elsif free>0
      hour = free.to_i / 3600
      free = free % 3600
      if hour>0
        hour.to_i.to_s << "小时前"
      elsif free>0
        min = free.to_i / 60
        free = free % 60
        if min>0
          min.to_i.to_s << "分钟前"
        elsif free>0
          free.to_i.to_s << "秒前"
        else
          '刚刚'
        end
      else
        '刚刚'
      end
    else
      '刚刚';
    end
  end 
  
  def message_images_first_url
    if message_images.present?
      message_images.first.image.url
    end
  end
  
end