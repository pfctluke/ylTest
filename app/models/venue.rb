class Venue < ActiveRecord::Base
  
  has_many :users
  has_many :venue_images, :dependent => :destroy
  
  attr_accessible :name, :address, :lat, :lon, :phone, :venue_images, :venue_images_attributes
  accepts_nested_attributes_for :venue_images, :reject_if => lambda { |a| a[:image].blank? }, :allow_destroy => true
  
  
  has_attached_file :logo,                                                                          
                    #:styles => { :small => "150x150>"},                  
                    :url  => "/external_storage/pictures/venue_logo/:basename.:extension",  
                    :path => ':rails_root/public/external_storage/pictures/venue_logo/:basename.:extension',
                    :default_url => '/assets/default_venue.png'
                    
  validates_presence_of :name, :message =>"请输入场馆名称！"
  validates_presence_of :lon, :message =>"请输入场馆经度！"
  validates_presence_of :lat, :message =>"请输入场馆纬度！"
  validates_presence_of :address, :message =>"请输入场馆地址！"
  
  validates_length_of :name, :maximum => 255,:message=>"名称长度不能超过255个字！"
  validates_length_of :address, :maximum => 255,:message=>"地址长度不能超过255个字！"
end