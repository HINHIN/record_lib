class AddArtistNameUniquenessIndex < ActiveRecord::Migration
  def up
    remove_index :artists, :name
    add_index :artists, :name, :unique => true
  end

  def down
    remove_index :artists, :name
  end
end
