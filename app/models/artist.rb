class Artist < ActiveRecord::Base
  attr_accessible :description, :name
  validates :name, :length => { :maximum => 255 } ,:presence => true, :uniqueness => {:case_sensitive => false}
  validates :description, :length => { :maximum => 2000 }
  
  has_many :artist_alboms, :dependent => :destroy
  has_many :alboms, :through => :artist_alboms
  
  has_many :artist_songs, :dependent => :destroy
  has_many :songs, :through => :artist_songs
end
