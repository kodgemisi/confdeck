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

ActiveRecord::Schema.define(:version => 20131019182304) do

  create_table "addresses", :force => true do |t|
    t.text     "info"
    t.float    "lat"
    t.float    "lon"
    t.integer  "conference_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "city"
  end

  create_table "appeals", :force => true do |t|
    t.integer  "conference_id"
    t.integer  "topic_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "conferences", :force => true do |t|
    t.string   "name"
    t.string   "summary"
    t.text     "description"
    t.string   "website"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "heading_image_file_name"
    t.string   "heading_image_content_type"
    t.integer  "heading_image_file_size"
    t.datetime "heading_image_updated_at"
  end

  create_table "conferences_days", :id => false, :force => true do |t|
    t.integer "conference_id"
    t.integer "day_id"
  end

  create_table "conferences_organizations", :id => false, :force => true do |t|
    t.integer "conference_id"
    t.integer "organization_id"
  end

  create_table "days", :force => true do |t|
    t.date     "date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "invitations", :force => true do |t|
    t.string   "email"
    t.integer  "organization_id"
    t.string   "token"
    t.boolean  "active",          :default => true
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "organizations_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "organization_id"
  end

  create_table "rooms", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "conference_id"
  end

  create_table "slots", :force => true do |t|
    t.time     "start_hour"
    t.integer  "duration"
    t.integer  "conference_id"
    t.integer  "day_id"
    t.integer  "room_id"
    t.integer  "topic_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "speakers", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "phone"
    t.string   "twitter"
    t.string   "facebook"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "bio"
    t.string   "github"
  end

  create_table "speakers_topics", :id => false, :force => true do |t|
    t.integer "speaker_id"
    t.integer "topic_id"
  end

  create_table "sponsors", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.integer  "conference_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "topics", :force => true do |t|
    t.string   "subject"
    t.string   "abstract"
    t.text     "detail"
    t.text     "additional_info"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
