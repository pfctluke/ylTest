class VenueImage < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :id, :venue_id, :image, :image_string
  
  belongs_to :venue
  
  has_attached_file :image, 
  # preserve_files: true, :processors => [:thumbnail, :watermark], 
    :styles =>{ 
      :thumb => '123x85!', 
      # :small =>{
        # :geometry => '260x180!',
        #:watermark_path => "#{Rails.root}/public/images/watermark_small.png",
        #:watermark_margin => '+6+6',
        #:position => 'SouthEast'
      # }, 
      :medium => {
        :geometry => '520x360!',
        #:watermark_path => "#{Rails.root}/public/images/watermark.png",
        #:watermark_margin => '+18+18',
        #:position => 'SouthEast'
      }, 
      # :large => {
        # :geometry => '1040x720!',
        #:watermark_path => "#{Rails.root}/public/images/watermark_large.png",
        #:watermark_margin => '+31+31',
        #:position => 'SouthEast'
      # }
    }, 
    :url  => "/external_storage/pictures/venue_image/:id/:style/:basename.:extension", 
    :path => ':rails_root/public/external_storage/pictures/venue_image/:id/:style/:basename.:extension', 
    :default_url => '/assets/default.png'
  
  validates_attachment_size :image, :less_than => 5.megabytes, :message => "图片超出大小！请选择大小小于5M的图片"
  validates_attachment_content_type :image, :content_type => %w(image/jpeg image/png), :message => "图片格式请选择png,jpg"

  before_create :create_random_file_name
  before_update :update_random_file_name
  
  def create_random_file_name
    file_name = "suzhou-tennis-venue-image-"
    file_name = file_name << (Time.now.strftime("%Y%m%d%H%M%S") + rand(1000).to_s)
    extension = File.extname(image_file_name).downcase
    file_name = file_name<<"#{extension}"
    self.image.instance_write(:file_name, file_name)
  end
  
  #更新时判断是否修改文件名
  def update_random_file_name
    @image = self.class.find(self.id)
      if @image.image_file_name != self.image_file_name
        create_random_file_name
      end
  end
end
