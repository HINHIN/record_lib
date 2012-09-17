class RenameSongMeshupAndRemixFlag < ActiveRecord::Migration
  def up
    change_table :songs do |t|
      t.rename :remix, :is_remix
      t.rename :mesh_up, :is_mesh_up
    end
  end

  def down
    change_table :songs do |t|
      t.rename :is_remix, :remix
      t.rename :is_mesh_up, :mesh_up
    end
  end
end
