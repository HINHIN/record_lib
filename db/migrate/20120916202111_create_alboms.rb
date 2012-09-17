class CreateAlboms < ActiveRecord::Migration
  def change
    create_table :alboms do |t|
      t.string :name
      t.text :description
      t.boolean :compilation

      t.timestamps
    end
    add_index :alboms, :name
  end
end
