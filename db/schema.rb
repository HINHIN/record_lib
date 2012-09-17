# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120917002246) do

  create_table "alboms", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "compilation"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "alboms", ["name"], :name => "index_alboms_on_name"

  create_table "artist_alboms", :force => true do |t|
    t.integer  "artist_id"
    t.integer  "albom_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "artist_alboms", ["albom_id"], :name => "index_artist_alboms_on_albom_id"
  add_index "artist_alboms", ["artist_id", "albom_id"], :name => "index_artist_alboms_on_artist_id_and_albom_id", :unique => true
  add_index "artist_alboms", ["artist_id"], :name => "index_artist_alboms_on_artist_id"

  create_table "artist_songs", :force => true do |t|
    t.integer  "artist_id"
    t.integer  "song_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "artist_songs", ["artist_id", "song_id"], :name => "index_artist_songs_on_artist_id_and_song_id", :unique => true
  add_index "artist_songs", ["artist_id"], :name => "index_artist_songs_on_artist_id"
  add_index "artist_songs", ["song_id"], :name => "index_artist_songs_on_song_id"

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "artists", ["name"], :name => "index_artists_on_name", :unique => true

  create_table "mesh_ups", :force => true do |t|
    t.integer  "song_id"
    t.integer  "source_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "mesh_ups", ["song_id"], :name => "index_mesh_ups_on_song_id"
  add_index "mesh_ups", ["source_id", "song_id"], :name => "index_mesh_ups_on_source_id_and_song_id", :unique => true
  add_index "mesh_ups", ["source_id"], :name => "index_mesh_ups_on_source_id"

  create_table "remixes", :force => true do |t|
    t.integer  "song_id"
    t.integer  "source_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "remixes", ["song_id"], :name => "index_remixes_on_song_id"
  add_index "remixes", ["source_id", "song_id"], :name => "index_remixes_on_source_id_and_song_id", :unique => true
  add_index "remixes", ["source_id"], :name => "index_remixes_on_source_id"

  create_table "songs", :force => true do |t|
    t.integer  "albom_id"
    t.integer  "time"
    t.string   "name"
    t.boolean  "is_remix"
    t.boolean  "is_mesh_up"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "songs", ["albom_id"], :name => "index_songs_on_albom_id"
  add_index "songs", ["is_mesh_up"], :name => "index_songs_on_mesh_up"
  add_index "songs", ["is_remix"], :name => "index_songs_on_remix"
  add_index "songs", ["name"], :name => "index_songs_on_name"

end
