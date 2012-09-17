class MeshUp < ActiveRecord::Base
  validates :song_id, :presence => true
  validates :source_id, :presence => true
  
  belongs_to :source, :class_name => "Song"
  belongs_to :song, :class_name => "Song" 
end
