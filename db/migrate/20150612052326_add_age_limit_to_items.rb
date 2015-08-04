class AddAgeLimitToItems < ActiveRecord::Migration
  def change
    add_column :items, :age_limit_type, :integer, default: 0
    add_column :items, :min_age, :integer
    add_column :items, :max_age, :integer
  end
end
