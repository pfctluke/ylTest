class AddAttachmentImageToCompetitions < ActiveRecord::Migration
  def self.up
    change_table :competitions do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :competitions, :image
  end
end
