class Club < ActiveRecord::Base
  attr_accessible :name, :introduction, :field, :membership, :phone, :status, :logo
  
  has_many :club_user_relationships
  has_many :users, :through => :club_user_relationships
  
  has_attached_file :logo,                                                                          
                    :styles => { :small => "114x114#"},               
                    :url  => "/external_storage/pictures/club_logo/:basename.:extension",  
                    :path => ':rails_root/public/external_storage/pictures/club_logo/:basename.:extension',
                    :default_url => '/assets/default_club.png'
                    
  validates_attachment_content_type :logo, :content_type => ['image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png'], :message => '请选择jpg或png格式的图片文件。'
  validates_attachment_size :logo, :less_than => 512.kilobytes, :message => "图片超出大小"
  validates_length_of :name, :maximum => 30, :message=>"用户名长度请控制在30个字之内"
  
  before_create :create_random_file_name
  before_update :update_file_name
  
  
  def update_file_name
    @user = self.class.find(self.id)
    if @user.logo_file_name != self.logo_file_name
      create_random_file_name
    end
  end
  
  def small_logo_url
    logo.url(:small)       
  end   
  
  def create_random_file_name
    if !logo_file_name.blank?
      file_name = "suzhou-tennis-club-logo-"
      file_name = file_name << (Time.now.strftime("%Y%m%d%H%M%S") + rand(1000).to_s)
      extension = File.extname(logo_file_name).downcase
      file_name = file_name<<"#{extension}"
      self.logo.instance_write(:file_name, file_name)
    end
  end
  
  def show_status
    if self.status == 1
      "待审核"
    elsif self.status == 2
      "已通过"
    else 
      "已拒绝"
    end
  end
end
