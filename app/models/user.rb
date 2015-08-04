class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role, :club_id, :phone, :valid_code, 
                  :valid_code_create_at, :full_name, :personal_signature, :sex, :profile_picture,:profile_picture_file_name,
                  :created_at, :last_sign_in_at, :nickname, :birthday, :address, :company, :club_name, :tennis_age, :status, :is_coach, :new_phone,
                  :approval_time, :annual_fee_validity
  # attr_accessible :title, :body
  
  has_many :club_user_relationships
  has_many :clubs, :through => :club_user_relationships
  has_many :message, :dependent => :destroy
  has_many :orders
  
  has_attached_file :profile_picture,                                                                          
                    :styles => { :small => "114x114#"},                  
                    :url  => "/external_storage/pictures/profile_picture/:id/:style/:basename.:extension",  
                    :path => ':rails_root/public/external_storage/pictures/profile_picture/:id/:style/:basename.:extension',
                    :default_url => '/assets/default_head.png'
  
  validates_attachment_content_type :profile_picture, :content_type => ['image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png'], :message => '请选择jpg或png格式的图片文件。'
  validates_attachment_size :profile_picture, :less_than => 512.kilobytes, :message => "图片超出大小"
  validates_length_of :full_name, :maximum => 30, :message=>"姓名长度请控制在30个字之内"
  validates_length_of :nickname, :maximum => 30, :message=>"昵称长度请控制在30个字之内"
  
  before_create :create_random_file_name
  before_update :update_file_name
  
  
  def update_file_name
    @user = self.class.find(self.id)
    if @user.profile_picture_file_name != self.profile_picture_file_name
      create_random_file_name
    end
  end
                    
  def profile_picture_url
    profile_picture.url(:small)
  end
  
  def small_profile_picture_url
    profile_picture.url(:small)       
  end   
  
  def create_random_file_name
    if !profile_picture_file_name.blank?
      file_name = "suzhou-tennis-"
      file_name = file_name << Time.now.strftime("%Y%m%d%H%M%S")
      extension = File.extname(profile_picture_file_name).downcase
      file_name = file_name<<"#{extension}"
      self.profile_picture.instance_write(:file_name, file_name)
    end
  end
  
  def admin?
    self.role == "admin"
  end
  
  def show_role
    if self.role == "admin"
      "管理员"
    else
      if self.status == 0
        "一般用户"
      else
        "网协会员"
      end
    end
  end
                 
  def show_birthday
    if self.birthday.present?
      self.birthday.strftime('%Y.%m.%d').to_s
    end
  end
  
  def show_status
    if self.status == 0
      "未申请"
    elsif self.status == 1
      "待审核"
    elsif self.status == 2
      "已通过"
    else 
      "已拒绝"
    end
  end
  
  def show_annual_fee_validity_status
    now = Time.new
    if self.annual_fee_validity.blank? || now - self.annual_fee_validity.to_time >= 0
      "已到期"
    else
      "未到期"
    end
  end
  
  def is_annual_fee_validity
    now = Time.new
    if self.annual_fee_validity.blank? || now - self.annual_fee_validity.to_time >= 0
      false
    else
      true
    end
  end
  
  def getAge
    if self.birthday.present?
      Time.new.year - self.birthday.to_time.year
    else
      0
    end
  end
end
