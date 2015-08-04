class AddIsCoachToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_coach, :boolean, default: false
  end
end
