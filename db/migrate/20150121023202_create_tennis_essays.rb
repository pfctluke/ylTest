class CreateTennisEssays < ActiveRecord::Migration
  def change
    create_table :tennis_essays do |t|
      t.string :title
      t.string :author
      t.string :author_des
      t.datetime :contribute_time
      t.text :body
      t.string :summary

      t.timestamps
    end
  end
end
