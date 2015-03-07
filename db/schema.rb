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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150307201405) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.integer  "subject_id"
    t.string   "subject_type"
    t.string   "action"
    t.integer  "conference_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["conference_id"], name: "index_activities_on_conference_id", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "addresses", force: true do |t|
    t.text     "info"
    t.float    "lat"
    t.float    "lon"
    t.integer  "conference_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "city"
  end

  create_table "comments", force: true do |t|
    t.string   "title",            limit: 50, default: ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "conference_roles", force: true do |t|
    t.integer  "user_id"
    t.integer  "conference_id"
    t.integer  "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conference_roles", ["conference_id"], name: "index_conference_roles_on_conference_id", using: :btree
  add_index "conference_roles", ["user_id"], name: "index_conference_roles_on_user_id", using: :btree

  create_table "conference_wizards", force: true do |t|
    t.text     "data"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conference_wizards", ["user_id"], name: "index_conference_wizards_on_user_id", using: :btree

  create_table "conferences", force: true do |t|
    t.string   "name"
    t.string   "summary"
    t.text     "description"
    t.string   "website"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "heading_image_file_name"
    t.string   "heading_image_content_type"
    t.integer  "heading_image_file_size"
    t.datetime "heading_image_updated_at"
    t.string   "keywords"
    t.string   "slug"
    t.string   "settings"
    t.datetime "application_end"
  end

  add_index "conferences", ["slug"], name: "index_conferences_on_slug", unique: true, using: :btree

  create_table "conferences_days", id: false, force: true do |t|
    t.integer "conference_id"
    t.integer "day_id"
  end

  create_table "conferences_organizations", id: false, force: true do |t|
    t.integer "conference_id"
    t.integer "organization_id"
  end

  create_table "days", force: true do |t|
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "email_template_types", force: true do |t|
    t.string   "type_name"
    t.text     "description"
    t.text     "default_body"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "title"
    t.string   "default_subject"
  end

  create_table "email_templates", force: true do |t|
    t.text     "body"
    t.string   "subject"
    t.integer  "conference_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "email_template_type_id"
  end

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "invitations", force: true do |t|
    t.string   "email"
    t.integer  "organization_id"
    t.string   "token"
    t.boolean  "active",          default: true
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "website"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "organizations_users", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "organization_id"
  end

  create_table "rooms", force: true do |t|
    t.string   "name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "conference_id"
  end

  create_table "slots", force: true do |t|
    t.integer  "conference_id"
    t.integer  "day_id"
    t.integer  "room_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "end_time"
    t.datetime "start_time"
    t.integer  "speech_id"
  end

  create_table "speakers", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "twitter"
    t.string   "facebook"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "bio"
    t.string   "github"
    t.integer  "user_id"
  end

  add_index "speakers", ["user_id"], name: "index_speakers_on_user_id", using: :btree

  create_table "speakers_topics", id: false, force: true do |t|
    t.integer "speaker_id"
    t.integer "topic_id"
  end

  create_table "speech_types", force: true do |t|
    t.integer  "conference_id"
    t.string   "type_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "speeches", force: true do |t|
    t.integer  "conference_id"
    t.integer  "topic_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "state"
    t.integer  "speech_type_id"
    t.integer  "email_status",            default: 0
    t.integer  "cached_votes_total",      default: 0
    t.integer  "cached_votes_score",      default: 0
    t.integer  "cached_votes_up",         default: 0
    t.integer  "cached_votes_down",       default: 0
    t.integer  "cached_weighted_score",   default: 0
    t.integer  "cached_weighted_total",   default: 0
    t.float    "cached_weighted_average", default: 0.0
  end

  add_index "speeches", ["cached_votes_down"], name: "index_speeches_on_cached_votes_down", using: :btree
  add_index "speeches", ["cached_votes_score"], name: "index_speeches_on_cached_votes_score", using: :btree
  add_index "speeches", ["cached_votes_total"], name: "index_speeches_on_cached_votes_total", using: :btree
  add_index "speeches", ["cached_votes_up"], name: "index_speeches_on_cached_votes_up", using: :btree
  add_index "speeches", ["cached_weighted_average"], name: "index_speeches_on_cached_weighted_average", using: :btree
  add_index "speeches", ["cached_weighted_score"], name: "index_speeches_on_cached_weighted_score", using: :btree
  add_index "speeches", ["cached_weighted_total"], name: "index_speeches_on_cached_weighted_total", using: :btree

  create_table "sponsors", force: true do |t|
    t.string   "name"
    t.string   "website"
    t.integer  "conference_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "topics", force: true do |t|
    t.string   "subject"
    t.text     "abstract"
    t.text     "detail"
    t.text     "additional_info"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "settings"
    t.integer  "role",                   default: 0
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["votable_id", "votable_type"], name: "index_votes_on_votable_id_and_votable_type", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type"], name: "index_votes_on_voter_id_and_voter_type", using: :btree

end
