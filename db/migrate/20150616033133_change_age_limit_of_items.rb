class ChangeAgeLimitOfItems < ActiveRecord::Migration
  def change
    remove_column :items, :min_age
    remove_column :items, :max_age
    add_column :items, :limit_age, :integer, default: 0
    add_column :items, :age_section_type, :integer, default: 0 #0小于，1大于
  end
end
