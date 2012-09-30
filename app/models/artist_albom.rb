class ArtistAlbom < ActiveRecord::Base
  validates :artist_id, :presence => true
  validates :albom_id, :presence => true
  
  belongs_to :artist
  belongs_to :albom
end
