class Albom < ActiveRecord::Base
  attr_accessible :compilation, :description, :name
  validates :name, :length => { :maximum => 255 }, :presence => true
  validates :description, :length => { :maximum => 2000 }
  
  has_many :songs
  
  has_many :artist_alboms, :dependent => :destroy
  has_many :artists, :through => :artist_alboms
end
