class Item < ActiveRecord::Base
  attr_accessible :kind, :name, :remark, :competition_id, :subitems_attributes, :age_limit_type, :limit_age, :age_section_type
  has_many :subitems, :dependent => :destroy
  has_many :units, :dependent => :destroy
  belongs_to :competition
  accepts_nested_attributes_for :subitems, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true
  
  #validates_presence_of :name, :message =>"请输入项目名称！"
  validates_presence_of :age_limit_type, :message =>"请选择年龄限制！"
  
  validates_length_of :name, :maximum => 255,:message=>"名称不能超过255个字！"
  validates_length_of :remark, :maximum => 255,:message=>"备注不能超过255个字！"
  
  validate :valid_age?
  validate :valid_kind?
  
  def valid_age?
    if self.age_limit_type > 0
      if self.limit_age.blank? || !self.limit_age.integer?
        errors.add(:from_age, "请输入有效的年龄！")
      end
    end
  end
  
  def valid_kind?
    if self.kind <= 0 || self.kind > 7
      errors.add(:from_age, "请选择比赛类型！")
    end
  end

  def show_age_limit
    @limit = ""
    @section_type = ""
    if self.age_limit_type == 0
      @limit = "无年龄限制"
    elsif self.age_limit_type == 1
      @limit = self.show_age
    elsif self.age_limit_type == 2
      if self.age_section_type == 0
        @limit = "年龄总和" + self.limit_age.to_s + "岁以下"
      else
        @limit = "年龄总和" + self.limit_age.to_s + "岁以上"
      end
    elsif self.age_limit_type == 3
      @limit = "男选手" + self.show_age
    end
    @limit
  end
  
  def show_age
    @age = ""
    if self.limit_age.present?
      if self.age_section_type == 0
        @age = self.limit_age.to_s + "岁以下" + "（" + (Time.new.year - self.limit_age - 1).to_s + "年12月31日之后出生）" 
      else
        @age = self.limit_age.to_s + "岁以上" + "（" + (Time.new.year - self.limit_age).to_s + "年1月1日之前出生）" 
      end
    end
  end
  
  def show_kind
    if self.kind == 1 
      "男子单打"
    elsif self.kind == 2
      "女子单打"
    elsif self.kind == 3
      "男子双打"
    elsif self.kind == 4
      "女子双打"
    elsif self.kind == 5
      "混合双打"
    elsif self.kind == 6
      "单打（男女混编）"
    else
      "双打（男女混编）"
    end
  end
  
  def show_full_name
    if self.name.present?
      self.name + "(" + self.show_kind + ")"
    else
      self.show_kind
    end
  end
end
