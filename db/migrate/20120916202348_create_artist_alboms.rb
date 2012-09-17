class CreateArtistAlboms < ActiveRecord::Migration
  def change
    create_table :artist_alboms do |t|
      t.integer :artist_id
      t.integer :albom_id

      t.timestamps
    end
    add_index :artist_alboms, :artist_id
    add_index :artist_alboms, :albom_id
    add_index :artist_alboms, [:artist_id, :albom_id], :unique => true
  end
end
