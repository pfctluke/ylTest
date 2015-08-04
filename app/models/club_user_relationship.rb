class ClubUserRelationship < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :club_id, :user_id, :permission
  
  belongs_to :user
  belongs_to :club
end
