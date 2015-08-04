class Carousel < ActiveRecord::Base
  
  before_create :create_random_file_name
  before_update :update_random_file_name
  
  attr_accessible :id, :title, :path, :photo
  
  has_attached_file :photo,                                                                          
                    :styles => { :medium => { :geometry => "1024x420^"}},                  
                    :convert_options => {:medium => "-gravity center -extent 1024x420" },
                    :url  => "/external_storage/pictures/carousel/:style/:basename.:extension",  
                    :path => ':rails_root/public/external_storage/pictures/carousel/:style/:basename.:extension',
                    :default_url => '/assets/default.png'
                    
  def get_title
    if self.title.size > 12
      self.title[0..11]<<"..."
    else
      self.title
    end
  end
  
  def create_random_file_name
    file_name = "suzhou-tennis-carousel-"
    file_name = file_name << (Time.now.strftime("%Y%m%d%H%M%S") + rand(1000).to_s)
    extension = File.extname(photo_file_name).downcase
    file_name = file_name<<"#{extension}"
    self.photo.instance_write(:file_name, file_name)
  end
  
  def update_random_file_name
    @model = self.class.find(self.id)
    if @model.photo_file_name != self.photo_file_name
      file_name = "suzhou-tennis-carousel-"
      file_name = file_name << (Time.now.strftime("%Y%m%d%H%M%S") + rand(1000).to_s)
      extension = File.extname(photo_file_name).downcase
      file_name = file_name<<"#{extension}"
      self.photo.instance_write(:file_name, file_name)
    end
  end
  
end