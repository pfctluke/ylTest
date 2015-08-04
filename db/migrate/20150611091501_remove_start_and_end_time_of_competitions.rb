class RemoveStartAndEndTimeOfCompetitions < ActiveRecord::Migration
  def change
    remove_column :competitions, :start_time
    remove_column :competitions, :end_time
  end
end
