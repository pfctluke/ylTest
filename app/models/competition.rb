class Competition < ActiveRecord::Base
  attr_accessible :name, :address, :rule, :kind, :competition_days_attributes, :image,
                  :first_game_day, :show_on_home_page#值为1时便是显示首页
  has_many :competition_days, :dependent => :destroy
  has_many :items, :dependent => :destroy
  
  accepts_nested_attributes_for :competition_days, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true
  
  has_attached_file :image,                                                                          
                    :styles => { :small => "114x114#"},               
                    :url  => "/external_storage/pictures/competition_image/:basename.:extension",  
                    :path => ':rails_root/public/external_storage/pictures/competition_image/:basename.:extension',
                    :default_url => '/assets/default_competition.png'
  
  validates_presence_of :name, :message =>"请输入赛事名称！"
  validates_presence_of :kind, :message => "请选择赛事类型！"
  validates_presence_of :address, :message =>"请输入地点！"
  validates_presence_of :rule, :message =>"请输入赛事规程！"
  
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png'], :message => '请选择jpg或png格式的图片文件。'
  validates_attachment_size :image, :less_than => 512.kilobytes, :message => "图片超出大小"
  
  validates_length_of :name, :maximum => 255,:message=>"名称不能超过255个字！"
  validates_length_of :address, :maximum => 255,:message=>"地点不能超过255个字！"
  
  before_create :create_random_file_name
  before_update :update_file_name
  
  
  def update_file_name
    @user = self.class.find(self.id)
    if @user.image_file_name != self.image_file_name
      create_random_file_name
    end
  end
  
  def small_image_url
    image.url(:small)       
  end   
  
  def create_random_file_name
    if image_file_name.blank?
      file_name = "suzhou-tennis-competition-image-"
      file_name = file_name << (Time.now.strftime("%Y%m%d%H%M%S") + rand(1000).to_s)
      extension = File.extname(image_file_name).downcase
      file_name = file_name<<"#{extension}"
      self.image.instance_write(:file_name, file_name)
    end
  end
  
  def show_kind
    if self.kind.to_i == 0
      "团体赛"
    else
      "个人赛"
    end
  end
  
  #显示毕设的起止日期
  def competition_time
    if self.competition_days.present?
      if self.competition_days.size == 1
        return self.competition_days[0].show_time
      else
        return self.competition_days.order("game_day asc")[0].show_time<<"-"<<self.competition_days.order("game_day asc")[-1].show_time
      end
    else
      return ""
    end
  end
  
  #第一个比赛日
  def first_game_day
    if self.competition_days.present?
      if self.competition_days.size == 1
        return self.competition_days[0].game_day
      end
    else
      return nil
    end
  end
  
end
