# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 20_250_530_222_030) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pg_catalog.plpgsql'

  create_table 'articles', force: :cascade do |t|
    t.string 'title'
    t.text 'abstract'
    t.string 'file'
    t.bigint 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_articles_on_user_id'
  end

  create_table 'events', force: :cascade do |t|
    t.string 'title'
    t.text 'description'
    t.datetime 'start_date'
    t.datetime 'end_date'
    t.string 'address'
    t.float 'latitude'
    t.float 'longitude'
    t.bigint 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_events_on_user_id'
  end

  create_table 'follows', force: :cascade do |t|
    t.bigint 'follower_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'followable_type'
    t.bigint 'followable_id'
    t.index %w[followable_type followable_id], name: 'index_follows_on_followable'
    t.index ['follower_id'], name: 'index_follows_on_follower_id'
  end

  create_table 'solid_profiles', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.string 'webid'
    t.string 'inbox_url'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_solid_profiles_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.integer 'role', default: 0, null: false
    t.float 'latitude'
    t.float 'longitude'
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.string 'jti', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'address'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['jti'], name: 'index_users_on_jti', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'articles', 'users'
  add_foreign_key 'events', 'users'
  add_foreign_key 'follows', 'users', column: 'follower_id'
  add_foreign_key 'solid_profiles', 'users'
end
