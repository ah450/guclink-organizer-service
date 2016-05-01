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

ActiveRecord::Schema.define(version: 20160501114012) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "topic_id",   null: false
  end

  add_index "courses", ["name"], name: "index_courses_on_name", using: :btree
  add_index "courses", ["topic_id"], name: "index_courses_on_topic_id", using: :btree

  create_table "event_invitations", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "rejected",   default: false, null: false
  end

  add_index "event_invitations", ["event_id"], name: "index_event_invitations_on_event_id", using: :btree
  add_index "event_invitations", ["user_id"], name: "index_event_invitations_on_user_id", using: :btree

  create_table "event_subscriptions", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "event_subscriptions", ["user_id", "event_id"], name: "index_event_subscriptions_on_user_id_and_event_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "title",                       null: false
    t.string   "description",                 null: false
    t.datetime "start_date",                  null: false
    t.datetime "end_date",                    null: false
    t.integer  "num_likes",   default: 0,     null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "private",     default: false, null: false
    t.integer  "user_id"
  end

  add_index "events", ["created_at"], name: "index_events_on_created_at", using: :btree

  create_table "exams", force: :cascade do |t|
    t.integer  "course_id"
    t.datetime "start_date", null: false
    t.datetime "end_date",   null: false
    t.string   "location",   null: false
    t.string   "seat",       null: false
    t.string   "exam_type",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "exams", ["course_id"], name: "index_exams_on_course_id", using: :btree
  add_index "exams", ["user_id"], name: "index_exams_on_user_id", using: :btree

  create_table "gcm_organizer_ids", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "gcm",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "gcm_organizer_ids", ["user_id"], name: "index_gcm_organizer_ids_on_user_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.string   "type",        null: false
    t.string   "title",       null: false
    t.string   "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "topic"
    t.integer  "sender_id"
    t.integer  "receiver_id"
  end

  add_index "notifications", ["receiver_id"], name: "index_notifications_on_receiver_id", using: :btree
  add_index "notifications", ["sender_id"], name: "index_notifications_on_sender_id", using: :btree
  add_index "notifications", ["type"], name: "index_notifications_on_type", using: :btree

  create_table "reset_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "reset_tokens", ["user_id", "token"], name: "index_reset_tokens_on_user_id_and_token", using: :btree
  add_index "reset_tokens", ["user_id"], name: "index_reset_tokens_on_user_id", using: :btree

  create_table "schedule_slots", force: :cascade do |t|
    t.integer  "course_id"
    t.string   "location"
    t.string   "group"
    t.string   "name",           null: false
    t.integer  "day",            null: false
    t.integer  "slot_num",       null: false
    t.boolean  "tutorial",       null: false
    t.boolean  "lecture",        null: false
    t.boolean  "lab",            null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "topic_id",       null: false
    t.string   "group_topic_id", null: false
  end

  add_index "schedule_slots", ["course_id"], name: "index_schedule_slots_on_course_id", using: :btree
  add_index "schedule_slots", ["group_topic_id"], name: "index_schedule_slots_on_group_topic_id", using: :btree
  add_index "schedule_slots", ["topic_id"], name: "index_schedule_slots_on_topic_id", using: :btree

  create_table "student_fetched_infos", force: :cascade do |t|
    t.integer  "guc_id_prefix", null: false
    t.integer  "guc_id_suffix", null: false
    t.string   "name",          null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id",       null: false
  end

  add_index "student_fetched_infos", ["guc_id_prefix", "guc_id_suffix"], name: "index_student_fetched_infos_on_guc_id_prefix_and_guc_id_suffix", using: :btree
  add_index "student_fetched_infos", ["user_id"], name: "index_student_fetched_infos_on_user_id", using: :btree

  create_table "student_registrations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "schedule_slot_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "student_registrations", ["schedule_slot_id"], name: "index_student_registrations_on_schedule_slot_id", using: :btree
  add_index "student_registrations", ["user_id"], name: "index_student_registrations_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest",                              null: false
    t.boolean  "student",                                      null: false
    t.boolean  "verified",                     default: false, null: false
    t.boolean  "super_user",                   default: false, null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "received_notifications_count", default: 0,     null: false
    t.integer  "sent_notifications_count",     default: 0,     null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["student"], name: "index_users_on_student", using: :btree
  add_index "users", ["super_user"], name: "index_users_on_super_user", using: :btree

  create_table "verification_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "verification_tokens", ["user_id", "token"], name: "index_verification_tokens_on_user_id_and_token", using: :btree
  add_index "verification_tokens", ["user_id"], name: "index_verification_tokens_on_user_id", using: :btree

  add_foreign_key "event_invitations", "events", on_delete: :cascade
  add_foreign_key "event_invitations", "users", on_delete: :cascade
  add_foreign_key "event_subscriptions", "events", on_delete: :cascade
  add_foreign_key "event_subscriptions", "users", on_delete: :cascade
  add_foreign_key "events", "users", on_delete: :cascade
  add_foreign_key "exams", "courses", on_delete: :cascade
  add_foreign_key "exams", "users"
  add_foreign_key "gcm_organizer_ids", "users", on_delete: :cascade
  add_foreign_key "notifications", "users", column: "receiver_id", on_delete: :nullify
  add_foreign_key "notifications", "users", column: "sender_id", on_delete: :nullify
  add_foreign_key "reset_tokens", "users", on_delete: :cascade
  add_foreign_key "schedule_slots", "courses", on_delete: :cascade
  add_foreign_key "student_fetched_infos", "users", on_delete: :cascade
  add_foreign_key "student_registrations", "schedule_slots", on_delete: :cascade
  add_foreign_key "student_registrations", "users", on_delete: :cascade
  add_foreign_key "verification_tokens", "users", on_delete: :cascade
end
