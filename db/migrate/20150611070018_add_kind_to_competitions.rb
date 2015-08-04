class AddKindToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :kind, :integer
  end
end
