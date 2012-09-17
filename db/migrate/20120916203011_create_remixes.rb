class CreateRemixes < ActiveRecord::Migration
  def change
    create_table :remixes do |t|
      t.integer :song_id
      t.integer :source_id

      t.timestamps
    end
    add_index :remixes, :source_id
    add_index :remixes, :song_id
    add_index :remixes, [:source_id, :song_id], :unique => true
  end
end
