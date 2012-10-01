class Song < ActiveRecord::Base
  attr_accessible :is_mesh_up, :name, :is_remix, :time
  
  validates :name, :length => { :maximum => 255 }, :presence => true
  validates :time, :numericality => {:greater_than =>0, :less_than=>2000000, :only_integer => true}
  belongs_to :albom
  
  has_many :artist_songs, :dependent => :destroy
  has_many :artists, :through => :artist_songs
  
  has_many :mesh_up, :foreign_key => "song_id", :dependent => :destroy
  has_many :meshs, :through => :mesh_up , :source => :source
  
  has_many :mesh_up_rev, :foreign_key => "source_id", :class_name => "MeshUp", :dependent => :destroy
  has_many :source_mesh_up, :through => :mesh_up_rev , :source => :song
  
  has_many :remix, :foreign_key => "song_id", :dependent => :destroy
  has_many :remixes, :through => :remix , :source => :source
  
  has_many :remix_rev, :foreign_key => "source_id", :class_name => "Remix", :dependent => :destroy
  has_many :source_remix, :through => :remix_rev , :source => :song
  
end
