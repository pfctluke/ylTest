class ChangeClubsColumnType < ActiveRecord::Migration
  def change
    #change_column :clubs, :logo_file_size, :integer
    execute 'ALTER TABLE clubs ALTER COLUMN logo_file_size TYPE integer USING (logo_file_size::integer)'
  end
end
