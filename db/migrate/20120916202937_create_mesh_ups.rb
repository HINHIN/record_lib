class CreateMeshUps < ActiveRecord::Migration
  def change
    create_table :mesh_ups do |t|
      t.integer :song_id
      t.integer :source_id

      t.timestamps
    end
    add_index :mesh_ups, :source_id
    add_index :mesh_ups, :song_id
    add_index :mesh_ups, [:source_id, :song_id], :unique => true
  end
end
