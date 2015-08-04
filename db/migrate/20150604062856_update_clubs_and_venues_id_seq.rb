class UpdateClubsAndVenuesIdSeq < ActiveRecord::Migration
  def change
    #由于这两张表中有预先设置的数据，故以此来更新id序列
    seq_name = ActiveRecord::Base.connection.quote("clubs_id_seq")
    execute "WITH mx AS ( SELECT MAX(id) AS id FROM clubs) SELECT setval(#{seq_name}, mx.id) AS curseq FROM mx"
    seq_name = ActiveRecord::Base.connection.quote("venues_id_seq")
    execute "WITH mx AS ( SELECT MAX(id) AS id FROM venues) SELECT setval(#{seq_name}, mx.id) AS curseq FROM mx"
  end
end
