class AddAShowFlagForCompetitions < ActiveRecord::Migration
  def self.up
    add_column :competitions, :show_on_home_page, :integer, default: 0
  end

  def self.down
    remove_column :competitions, :show_on_home_page
  end
end
