# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090217171965) do

  create_table "challenges", :force => true do |t|
    t.string   "name"
    t.integer  "level"
    t.integer  "score"
    t.integer  "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "challenges_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "challenge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "challenges_users", ["challenge_id", "user_id"], :name => "index_challenges_users_on_challenge_id_and_user_id"
  add_index "challenges_users", ["user_id"], :name => "index_challenges_users_on_user_id"

  create_table "ctf_logs", :force => true do |t|
    t.string   "event_name"
    t.string   "event_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "mail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
