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

ActiveRecord::Schema.define(version: 20160808140800) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "democ_detail_records", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "representative_type"
    t.integer  "record_type"
    t.integer  "requestor_number"
    t.integer  "policy_type"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.string   "valid_policy_number"
    t.string   "current_policy_status"
    t.date     "current_policy_status_effective_date"
    t.integer  "policy_year"
    t.string   "policy_year_rating_plan"
    t.string   "claim_indicator"
    t.string   "claim_number"
    t.date     "claim_injury_date"
    t.string   "claim_combined"
    t.string   "combined_into_claim_number"
    t.string   "claim_rating_plan_indicator"
    t.string   "claim_status"
    t.date     "claim_status_effective_date"
    t.integer  "claim_manual_number"
    t.string   "claim_sub_manual_number"
    t.string   "claim_type"
    t.date     "claimant_date_of_death"
    t.string   "claim_activity_status"
    t.date     "claim_activity_status_effective_date"
    t.string   "settled_claim"
    t.string   "settlement_type"
    t.date     "medical_settlement_date"
    t.date     "indemnity_settlement_date"
    t.date     "maximum_medical_improvement_date"
    t.date     "last_paid_medical_date"
    t.date     "last_paid_indemnity_date"
    t.float    "average_weekly_wage"
    t.float    "full_weekly_wage"
    t.string   "claim_handicap_percent"
    t.date     "claim_handicap_percent_effective_date"
    t.string   "claim_mira_ncci_injury_type"
    t.integer  "claim_medical_paid"
    t.integer  "claim_mira_medical_reserve_amount"
    t.integer  "claim_mira_non_reducible_indemnity_paid"
    t.integer  "claim_mira_reducible_indemnity_paid"
    t.integer  "claim_mira_indemnity_reserve_amount"
    t.string   "industrial_commission_appeal_indicator"
    t.integer  "claim_mira_non_reducible_indemnity_paid_2"
    t.integer  "claim_total_subrogation_collected"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "democs", force: :cascade do |t|
    t.string "single_rec"
  end

  create_table "mrcls", force: :cascade do |t|
    t.string "single_rec"
  end

  create_table "mremps", force: :cascade do |t|
    t.string "single_rec"
  end

  create_table "pcombs", force: :cascade do |t|
    t.string "single_rec"
  end

  create_table "phmgns", force: :cascade do |t|
    t.string "single_rec"
  end

  create_table "sc220s", force: :cascade do |t|
    t.string "single_rec"
  end

  create_table "sc230s", force: :cascade do |t|
    t.string "single_rec"
  end

end
