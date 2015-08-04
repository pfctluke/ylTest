class MessageImage < ActiveRecord::Base
  
  attr_accessible :id, :message_id, :image
  belongs_to :message
  
  has_attached_file :image,                                                                          
                    :styles => { :small => "500x9999999999>" },
                    :url  => "/external_storage/pictures/message_image/:id/:basename.:extension",  
                    :path => ':rails_root/public/external_storage/pictures/message_image/:id/:basename.:extension',
                    :default_url => '/assets/default.png'                  
                    # :url  => "/pictures/message_image/:id/:style/:basename.:extension",  
                    # :path => ':rails_root/public/pictures/message_image/:id/:style/:basename.:extension',
                    # :default_url => '/assets/default.png'
  
  validates_attachment_size :image, :less_than => 5.megabytes, :message => "图片超出大小！请选择大小小于5M的图片"
  validates_attachment_content_type :image, :content_type => %w(image/jpeg image/png), :message => "图片格式请选择png,jpg"
  
  before_create :create_random_file_name
  before_update :update_random_file_name
  
  def create_random_file_name
    file_name = "suzhou-tennis-message-"
    file_name = file_name << (Time.now.strftime("%Y%m%d%H%M%S") + rand(1000).to_s)
    extension = File.extname(image_file_name).downcase
    file_name = file_name<<"#{extension}"
    self.image.instance_write(:file_name, file_name)
  end
  
  def update_random_file_name
    @model = self.class.find(self.id)
    if @model.image_file_name != self.image_file_name
      file_name = "suzhou-tennis-message-"
      file_name = file_name << (Time.now.strftime("%Y%m%d%H%M%S") + rand(1000).to_s)
      extension = File.extname(image_file_name).downcase
      file_name = file_name<<"#{extension}"
      self.image.instance_write(:file_name, file_name)
    end
  end
  
end