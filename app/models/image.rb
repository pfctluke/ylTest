class Image < ActiveRecord::Base
  
  attr_accessible :id, :news_id, :photo, :image_string
  
  belongs_to :news
  
  has_attached_file :photo, 
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
    :url  => "/external_storage/pictures/news_image/:id/:style/:basename.:extension", 
    :path => ':rails_root/public/external_storage/pictures/news_image/:id/:style/:basename.:extension', 
    :default_url => '/assets/default.png'

  before_create :create_random_file_name
  before_update :update_random_file_name
  
  def create_random_file_name
    file_name = "suzhou-tennis-news-image-"
    file_name = file_name << Time.now.strftime("%Y%m%d%H%M%S")
    extension = File.extname(photo_file_name).downcase
    file_name = file_name<<"#{extension}"
    self.photo.instance_write(:file_name, file_name)
  end
  
  #更新时判断是否修改文件名
  def update_random_file_name
    @image = self.class.find(self.id)
      if @image.photo_file_name != self.photo_file_name
        create_random_file_name
      end
  end
  
end