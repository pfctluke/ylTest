class TennisEssay < ActiveRecord::Base
  attr_accessible :author_des, :author, :contribute_time, :body, :title, :summary
  
  def show_contribute_time
    if self.contribute_time.present?
      self.contribute_time.strftime('%F')
    else
      ''
    end
  end
  
  def get_summary
    if self.body.present?
      self.body[0..80]
    end
  end
  
  def get_author_des
    if self.author_des.present?
      "("<<self.author_des<<")"
    else
      ""
    end
  end
end
