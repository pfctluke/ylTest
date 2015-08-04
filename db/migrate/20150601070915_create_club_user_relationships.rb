class CreateClubUserRelationships < ActiveRecord::Migration
  def change
    create_table :club_user_relationships do |t|
      t.integer :club_id
      t.integer :user_id
      t.integer :permission, default: 1 #0负责人， 1会员
      t.timestamps
    end
  end
end
