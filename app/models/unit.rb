#比赛的基础作战单位，单打则表示选手，双打则表示两人组成的小组
class Unit < ActiveRecord::Base
  attr_accessible :first_player, :second_player, :team_id, :item_id
  
  belongs_to :team
  belongs_to :item
  
  validate :valid_players?
  validate :valid_age?
  validate :valid_sex?
  
  def valid_players?
    if self.first_player.blank?
      errors.add(:from_first_player_blank, (self.item.name + "：请选择选手一！"))
    end
    if self.item.kind.to_i > 2 && self.item.kind.to_i != 6
      if self.second_player.blank?
        errors.add(:from_second_player_blank, (self.item.name + "：请选择选手二！"))
      elsif self.first_player == self.second_player
        errors.add(:from_two_players_blank, (self.item.name + "：两位选手不能为同一人！"))
      end
    end
  end
  
  def valid_sex?
    if self.first_player.present? && self.second_player.present?
      @first_player = User.where(id: self.first_player).first
      @second_player = User.where(id: self.second_player).first
      if @first_player.blank?
        errors.add(:from_first_player_nonexistent, (self.item.name + "：选手一不存在！"))
      elsif @second_player.blank?
        errors.add(:from_second_player_nonexistent, (self.item.name + "：选手二不存在！"))
      else
        if self.item.kind == 1 
          unless @first_player.sex.to_i == 1 
            errors.add(:from_player_sex_male, (self.item.name + "：选手性别仅限男性！"))
          end
        elsif self.item.kind == 2
          unless @first_player.sex.to_i == 0 
            errors.add(:from_player_sex_female, (self.item.name + "：选手性别仅限女性！"))
          end
        elsif self.item.kind == 3
          unless @first_player.sex.to_i == 1 && @second_player.sex.to_i == 1
            errors.add(:from_player_sex_male, (self.item.name + "：选手性别仅限男性！"))
          end
        elsif self.item.kind == 4
          unless @first_player.sex.to_i == 0 && @second_player.sex.to_i == 0
            errors.add(:from_player_sex_female, (self.item.name + "：选手性别仅限女性！"))
          end
        elsif self.item.kind == 5
          unless @first_player.sex.to_i != @second_player.sex.to_i
            errors.add(:from_player_sex_mix, (self.item.name + "：选手性别必须一男一女！"))
          end
        end
      end
    end
  end
  
  def valid_age?
    if self.first_player.present?
      @first_player = User.where(id: self.first_player).first
    end
    if self.second_player.present?
      @second_player = User.where(id: self.second_player).first
    end
    
    if self.item.age_limit_type == 1
      if @first_player.present?  
        if self.item.age_section_type == 0
          unless @first_player.getAge <= self.item.limit_age
            errors.add(:from_player_age_old, (self.item.name + "：选手年龄太大！"))
          end
        else
          unless @first_player.getAge >= self.item.limit_age
            errors.add(:from_player_age_young, (self.item.name + "：选手年龄太小！"))
          end
        end
      end
      if @second_player.present?
        if self.item.age_section_type == 0
          unless @second_player.getAge <= self.item.limit_age
            errors.add(:from_player_age_old, (self.item.name + "：选手年龄太大！"))
          end
        else
          unless @second_player.getAge >= self.item.limit_age
            errors.add(:from_player_age_young, (self.item.name + "：选手年龄太小！"))
          end
        end
      end
    elsif self.item.age_limit_type == 2 && @first_player.present? && @second_player.present?
      if self.item.age_section_type == 0
        unless (@first_player.getAge + @second_player.getAge) <= self.item.limit_age
          errors.add(:from_player_age_sum_old, (self.item.name + "：选手年龄总和太大！"))
        end
      else
        unless (@first_player.getAge + @second_player.getAge) >= self.item.limit_age
          errors.add(:from_player_age_sum_young, (self.item.name + "：选手年龄总和太小！"))
        end
      end
    elsif self.item.age_limit_type == 3
      if @first_player.present? && @first_player.sex.to_i == 1
        if self.item.age_section_type == 0
          unless @first_player.getAge <= self.item.limit_age
            errors.add(:from_player_age_male_old, (self.item.name + "：男选手年龄太大！"))
          end
        else
          unless @first_player.getAge >= self.item.limit_age
            errors.add(:from_player_age_male_young, (self.item.name + "：男选手年龄太小！"))
          end
        end
      end
      if @second_player.present? && @second_player.sex.to_i == 1
        if self.item.age_section_type == 0
          unless @second_player.getAge <= self.item.limit_age
            errors.add(:from_player_age_male_old, (self.item.name + "：男选手年龄太大！"))
          end
        else
          unless @second_player.getAge >= self.item.limit_age
            errors.add(:from_player_age_male_young, (self.item.name + "：男选手年龄太小！"))
          end
        end
      end
    end
  end
    
end
