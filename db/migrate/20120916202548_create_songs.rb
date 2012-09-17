class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.integer :albom_id
      t.integer :time
      t.string :name
      t.boolean :remix
      t.boolean :mesh_up

      t.timestamps
    end
    add_index :songs, :albom_id
    add_index :songs, :name
    add_index :songs, :remix
    add_index :songs, :mesh_up
    
  end
end
