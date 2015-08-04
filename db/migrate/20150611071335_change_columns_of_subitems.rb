class ChangeColumnsOfSubitems < ActiveRecord::Migration
  def change
    remove_column :subitems, :kind
    remove_column :subitems, :age_limit_type
    remove_column :subitems, :min_age
    remove_column :subitems, :max_age
    add_column :subitems, :title, :string
    add_column :subitems, :game_day, :timestamp
  end
end
