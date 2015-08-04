class AddAFirstGameDayForCompetitions < ActiveRecord::Migration
  def self.up
    add_column :competitions, :first_game_day, :timestamp
  end

  def self.down
    remove_column :competitions, :first_game_day
  end
end
