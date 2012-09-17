class CreateArtistSongs < ActiveRecord::Migration
  def change
    create_table :artist_songs do |t|
      t.integer :artist_id
      t.integer :song_id

      t.timestamps
    end
    add_index :artist_songs, :artist_id
    add_index :artist_songs, :song_id
    add_index :artist_songs, [:artist_id, :song_id], :unique => true
  end
end
