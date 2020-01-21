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

ActiveRecord::Schema.define(version: 20200121154729) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "account_programs", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "program_type"
    t.integer  "status"
    t.float    "fees_amount"
    t.float    "paid_amount"
    t.string   "invoice_number"
    t.string   "quote_generated"
    t.date     "quote_date"
    t.date     "quote_sent_date"
    t.date     "effective_start_date"
    t.date     "effective_end_date"
    t.date     "ac2_signed_on"
    t.date     "ac26_signed_on"
    t.date     "u153_signed_on"
    t.date     "contract_signed_on"
    t.date     "questionnaire_signed_on"
    t.date     "invoice_received_on"
    t.date     "program_paid_on"
    t.string   "group_code"
    t.string   "check_number"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.float    "quote_tier"
  end

  add_index "account_programs", ["account_id"], name: "index_account_programs_on_account_id", using: :btree

  create_table "accounts", force: :cascade do |t|
    t.integer  "representative_id"
    t.string   "name"
    t.integer  "policy_number_entered"
    t.string   "street_address"
    t.string   "street_address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.integer  "business_phone_number",         limit: 8
    t.string   "business_email_address"
    t.string   "website_url"
    t.integer  "group_rating_qualification"
    t.integer  "industry_group"
    t.float    "group_rating_tier"
    t.string   "group_rating_group_number"
    t.float    "group_premium"
    t.float    "group_savings"
    t.float    "group_fees"
    t.float    "group_dues"
    t.float    "total_costs"
    t.integer  "status",                                  default: 0
    t.string   "federal_identification_number"
    t.date     "cycle_date"
    t.date     "request_date"
    t.boolean  "quarterly_request"
    t.boolean  "weekly_request"
    t.boolean  "ac3_approval"
    t.boolean  "user_override"
    t.string   "group_retro_qualification"
    t.float    "group_retro_tier"
    t.string   "group_retro_group_number"
    t.float    "group_retro_premium"
    t.float    "group_retro_savings"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.float    "fee_override"
    t.float    "fee_change"
  end

  add_index "accounts", ["representative_id"], name: "index_accounts_on_representative_id", using: :btree

  create_table "accounts_affiliates", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "affiliate_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "accounts_affiliates", ["account_id"], name: "index_accounts_affiliates_on_account_id", using: :btree
  add_index "accounts_affiliates", ["affiliate_id"], name: "index_accounts_affiliates_on_affiliate_id", using: :btree

  create_table "accounts_contacts", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "accounts_contacts", ["account_id"], name: "index_accounts_contacts_on_account_id", using: :btree
  add_index "accounts_contacts", ["contact_id"], name: "index_accounts_contacts_on_contact_id", using: :btree

  create_table "accounts_contacts_contact_types", force: :cascade do |t|
    t.integer  "accounts_contact_id"
    t.integer  "contact_type_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "accounts_contacts_contact_types", ["accounts_contact_id"], name: "index_accounts_contacts_contact_types_on_accounts_contact_id", using: :btree
  add_index "accounts_contacts_contact_types", ["contact_type_id"], name: "index_accounts_contacts_contact_types_on_contact_type_id", using: :btree

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "affiliates", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "role",              default: 0
    t.string   "email_address"
    t.string   "salesforce_id"
    t.integer  "representative_id"
    t.integer  "internal_external", default: 0
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "external_id"
    t.string   "company_name"
  end

  add_index "affiliates", ["representative_id"], name: "index_affiliates_on_representative_id", using: :btree

  create_table "bwc_annual_manual_class_changes", force: :cascade do |t|
    t.integer  "manual_class_from"
    t.integer  "manual_class_to"
    t.integer  "policy_year"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "bwc_codes_base_rates_exp_loss_rates", force: :cascade do |t|
    t.integer  "class_code"
    t.float    "base_rate"
    t.float    "expected_loss_rate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bwc_codes_base_rates_historical_data", force: :cascade do |t|
    t.integer  "year"
    t.integer  "class_code"
    t.integer  "industry_group"
    t.float    "base_rate"
    t.float    "expected_loss_rate"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "bwc_codes_constant_values", force: :cascade do |t|
    t.string   "name"
    t.float    "rate"
    t.date     "start_date"
    t.date     "completed_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bwc_codes_credibility_max_losses", force: :cascade do |t|
    t.integer  "credibility_group"
    t.integer  "expected_losses"
    t.float    "credibility_percent"
    t.integer  "group_maximum_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bwc_codes_employer_representatives", force: :cascade do |t|
    t.integer  "rep_id"
    t.string   "employer_rep_name"
    t.string   "rep_id_text"
    t.integer  "representative_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bwc_codes_group_retro_tiers", force: :cascade do |t|
    t.integer  "industry_group"
    t.float    "discount_tier"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "bwc_codes_industry_group_savings_ratio_criteria", force: :cascade do |t|
    t.integer  "industry_group"
    t.float    "ratio_criteria"
    t.float    "average_ratio"
    t.float    "actual_decimal"
    t.float    "percent_value"
    t.float    "em"
    t.float    "market_rate"
    t.float    "market_em_rate"
    t.string   "sponsor"
    t.string   "ac26_group_level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bwc_codes_limited_loss_rates_historical_data", force: :cascade do |t|
    t.integer  "year"
    t.integer  "industry_group"
    t.integer  "credibility_group"
    t.float    "limited_loss_ratio"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "bwc_codes_limited_loss_ratios", force: :cascade do |t|
    t.integer  "industry_group"
    t.integer  "credibility_group"
    t.float    "limited_loss_ratio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bwc_codes_ncci_manual_classes", force: :cascade do |t|
    t.integer  "industry_group"
    t.integer  "ncci_manual_classification"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bwc_codes_peo_lists", force: :cascade do |t|
    t.string   "policy_type"
    t.integer  "policy_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bwc_codes_policy_effective_dates", force: :cascade do |t|
    t.integer  "policy_number"
    t.date     "policy_original_effective_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bwc_codes_policy_effective_dates", ["policy_number"], name: "index_bwc_codes_policy_effective_dates_on_policy_number", using: :btree

  create_table "bwc_group_accept_reject_lists", force: :cascade do |t|
    t.integer  "policy_number"
    t.string   "name"
    t.string   "tpa"
    t.string   "bwc_rep_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "claim_calculations", force: :cascade do |t|
    t.integer  "representative_number"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "policy_calculation_id"
    t.string   "claim_number"
    t.date     "claim_injury_date"
    t.float    "claim_handicap_percent"
    t.date     "claim_handicap_percent_effective_date"
    t.date     "claimant_date_of_death"
    t.date     "claimant_date_of_birth"
    t.string   "claimant_name"
    t.integer  "claim_manual_number"
    t.float    "claim_medical_paid"
    t.float    "claim_mira_medical_reserve_amount"
    t.float    "claim_mira_non_reducible_indemnity_paid"
    t.float    "claim_mira_reducible_indemnity_paid"
    t.float    "claim_mira_indemnity_reserve_amount"
    t.float    "claim_mira_non_reducible_indemnity_paid_2"
    t.float    "claim_total_subrogation_collected"
    t.float    "claim_unlimited_limited_loss"
    t.float    "policy_individual_maximum_claim_value"
    t.float    "claim_group_multiplier"
    t.float    "claim_individual_multiplier"
    t.float    "claim_group_reduced_amount"
    t.float    "claim_individual_reduced_amount"
    t.float    "claim_subrogation_percent"
    t.float    "claim_modified_losses_group_reduced"
    t.float    "claim_modified_losses_individual_reduced"
    t.string   "data_source"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "claim_combined"
    t.string   "combined_into_claim_number"
    t.string   "claim_rating_plan_indicator"
    t.string   "claim_status"
    t.date     "claim_status_effective_date"
    t.string   "claim_type"
    t.string   "claim_activity_status"
    t.date     "claim_activity_status_effective_date"
    t.string   "settled_claim"
    t.string   "settlement_type"
    t.date     "medical_settlement_date"
    t.date     "indemnity_settlement_date"
    t.date     "maximum_medical_improvement_date"
    t.string   "claim_mira_ncci_injury_type"
  end

  add_index "claim_calculations", ["policy_calculation_id"], name: "index_claim_calculations_on_policy_calculation_id", using: :btree
  add_index "claim_calculations", ["policy_number", "claim_number"], name: "index_claim_calc_on_pol_num_and_claim_num", using: :btree

  create_table "claim_note_categories", force: :cascade do |t|
    t.string   "title"
    t.text     "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "claim_notes", force: :cascade do |t|
    t.string   "title"
    t.integer  "claim_note_category_id"
    t.text     "body"
    t.integer  "claim_calculation_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "clicd_detail_records", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "record_type"
    t.integer  "requestor_number"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.string   "valid_policy_number"
    t.string   "current_policy_status"
    t.date     "current_policy_status_effective_date"
    t.integer  "policy_year"
    t.string   "policy_year_rating_plan"
    t.string   "claim_indicator"
    t.string   "claim_number"
    t.string   "icd_codes_assigned"
    t.string   "icd_code"
    t.string   "icd_status"
    t.date     "icd_status_effective_date"
    t.string   "icd_injury_location_code"
    t.string   "icd_digit_tooth_number"
    t.string   "primary_icd"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "clicds", force: :cascade do |t|
    t.string "single_rec"
  end

  create_table "contact_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.integer  "prefix",          default: 0
    t.string   "first_name"
    t.string   "middle_initial"
    t.string   "last_name"
    t.string   "suffix"
    t.string   "email_address"
    t.string   "phone_number"
    t.string   "phone_extension"
    t.string   "mobile_phone"
    t.string   "fax_number"
    t.string   "salesforce_id"
    t.string   "title"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "country"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "democ_detail_records", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "representative_type"
    t.integer  "record_type"
    t.integer  "requestor_number"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.string   "valid_policy_number"
    t.string   "current_policy_status"
    t.date     "current_policy_status_effective_date"
    t.string   "claimant_name"
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
    t.date     "claimant_date_of_birth"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "non_at_fault"
  end

  create_table "democs", force: :cascade do |t|
    t.string "single_rec"
  end

  create_table "exception_table_policy_combined_request_payroll_infos", force: :cascade do |t|
    t.string   "representative_number"
    t.string   "predecessor_policy_type"
    t.integer  "predecessor_policy_number"
    t.string   "successor_policy_type"
    t.integer  "successor_policy_number"
    t.string   "transfer_type"
    t.date     "transfer_effective_date"
    t.date     "transfer_creation_date"
    t.string   "payroll_origin"
    t.string   "data_source"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "final_claim_cost_calculation_tables", force: :cascade do |t|
    t.integer  "representative_number"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.string   "claim_number"
    t.date     "claim_injury_date"
    t.float    "claim_handicap_percent"
    t.string   "claimant_name"
    t.date     "claimant_date_of_birth"
    t.date     "claimant_date_of_death"
    t.date     "claim_handicap_percent_effective_date"
    t.integer  "claim_manual_number"
    t.float    "claim_medical_paid"
    t.float    "claim_mira_medical_reserve_amount"
    t.float    "claim_mira_non_reducible_indemnity_paid"
    t.float    "claim_mira_reducible_indemnity_paid"
    t.float    "claim_mira_indemnity_reserve_amount"
    t.float    "claim_mira_non_reducible_indemnity_paid_2"
    t.float    "claim_total_subrogation_collected"
    t.float    "claim_unlimited_limited_loss"
    t.float    "policy_individual_maximum_claim_value"
    t.float    "claim_group_multiplier"
    t.float    "claim_individual_multiplier"
    t.float    "claim_group_reduced_amount"
    t.float    "claim_individual_reduced_amount"
    t.float    "claim_subrogation_percent"
    t.float    "claim_modified_losses_group_reduced"
    t.float    "claim_modified_losses_individual_reduced"
    t.string   "data_source"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "claim_combined"
    t.string   "combined_into_claim_number"
    t.string   "claim_rating_plan_indicator"
    t.string   "claim_status"
    t.date     "claim_status_effective_date"
    t.string   "claim_type"
    t.string   "claim_activity_status"
    t.date     "claim_activity_status_effective_date"
    t.string   "settled_claim"
    t.string   "settlement_type"
    t.date     "medical_settlement_date"
    t.date     "indemnity_settlement_date"
    t.date     "maximum_medical_improvement_date"
    t.string   "claim_mira_ncci_injury_type"
  end

  add_index "final_claim_cost_calculation_tables", ["policy_number", "representative_number"], name: "index_cl_pol_num_and_rep", using: :btree

  create_table "final_employer_demographics_informations", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "policy_number"
    t.integer  "currently_assigned_representative_number"
    t.string   "valid_policy_number"
    t.string   "current_coverage_status"
    t.date     "coverage_status_effective_date"
    t.date     "policy_creation_date"
    t.string   "federal_identification_number"
    t.string   "business_name"
    t.string   "trading_as_name"
    t.string   "valid_mailing_address"
    t.string   "mailing_address_line_1"
    t.string   "mailing_address_line_2"
    t.string   "mailing_city"
    t.string   "mailing_state"
    t.integer  "mailing_zip_code"
    t.integer  "mailing_zip_code_plus_4"
    t.integer  "mailing_country_code"
    t.integer  "mailing_county"
    t.string   "valid_location_address"
    t.string   "location_address_line_1"
    t.string   "location_address_line_2"
    t.string   "location_city"
    t.string   "location_state"
    t.integer  "location_zip_code"
    t.integer  "location_zip_code_plus_4"
    t.integer  "location_country_code"
    t.integer  "location_county"
    t.integer  "currently_assigned_clm_representative_number"
    t.integer  "currently_assigned_risk_representative_number"
    t.integer  "currently_assigned_erc_representative_number"
    t.integer  "currently_assigned_grc_representative_number"
    t.integer  "immediate_successor_policy_number"
    t.integer  "immediate_successor_business_sequence_number"
    t.integer  "ultimate_successor_policy_number"
    t.integer  "ultimate_successor_business_sequence_number"
    t.string   "employer_type"
    t.string   "coverage_type"
    t.string   "policy_coverage_type"
    t.string   "policy_employer_type"
    t.float    "merit_rate"
    t.string   "group_code"
    t.string   "minimum_premium_percentage"
    t.string   "rate_adjust_factor"
    t.date     "em_effective_date"
    t.float    "regular_balance_amount"
    t.float    "attorney_general_balance_amount"
    t.float    "appealed_balance_amount"
    t.float    "pending_balance_amount"
    t.float    "advance_deposit_amount"
    t.string   "data_source"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "final_employer_demographics_informations", ["policy_number", "representative_number"], name: "index_emp_demo_pol_num_and_man_num", using: :btree

  create_table "final_manual_class_four_year_payroll_and_exp_losses", force: :cascade do |t|
    t.integer  "representative_number"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "manual_number"
    t.string   "manual_class_type"
    t.float    "manual_class_four_year_period_payroll"
    t.float    "manual_class_expected_loss_rate"
    t.float    "manual_class_base_rate"
    t.float    "manual_class_expected_losses"
    t.integer  "manual_class_industry_group"
    t.float    "manual_class_limited_loss_rate"
    t.float    "manual_class_limited_losses"
    t.string   "data_source"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "final_manual_class_four_year_payroll_and_exp_losses", ["policy_number", "manual_number", "representative_number"], name: "index_man_pr_pol_num_and_man_num_rep", using: :btree

  create_table "final_manual_class_group_rating_and_premium_projections", force: :cascade do |t|
    t.integer  "representative_number"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "manual_number"
    t.string   "manual_class_type"
    t.integer  "manual_class_industry_group"
    t.float    "manual_class_industry_group_premium_total"
    t.float    "manual_class_current_estimated_payroll"
    t.float    "manual_class_base_rate"
    t.float    "manual_class_industry_group_premium_percentage"
    t.float    "manual_class_modification_rate"
    t.float    "manual_class_individual_total_rate"
    t.float    "manual_class_group_total_rate"
    t.float    "manual_class_standard_premium"
    t.float    "manual_class_estimated_group_premium"
    t.float    "manual_class_estimated_individual_premium"
    t.string   "data_source"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "final_manual_class_group_rating_and_premium_projections", ["policy_number", "manual_number", "representative_number"], name: "index_fin_man_pr_pol_num_and_man_num_rep", using: :btree

  create_table "final_policy_experience_calculations", force: :cascade do |t|
    t.integer  "representative_number"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.string   "valid_policy_number"
    t.string   "policy_group_number"
    t.string   "policy_status"
    t.float    "policy_total_four_year_payroll"
    t.integer  "policy_credibility_group"
    t.integer  "policy_maximum_claim_value"
    t.float    "policy_credibility_percent"
    t.float    "policy_total_expected_losses"
    t.float    "policy_total_limited_losses"
    t.integer  "policy_total_claims_count"
    t.float    "policy_total_modified_losses_group_reduced"
    t.float    "policy_total_modified_losses_individual_reduced"
    t.float    "policy_group_ratio"
    t.float    "policy_individual_total_modifier"
    t.float    "policy_individual_experience_modified_rate"
    t.string   "data_source"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "final_policy_experience_calculations", ["policy_number", "representative_number"], name: "index_pol_exp_pol_num_and_man_num_rep", using: :btree

  create_table "final_policy_group_rating_and_premium_projections", force: :cascade do |t|
    t.integer  "representative_number"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "policy_industry_group"
    t.string   "policy_status"
    t.string   "group_rating_qualification"
    t.float    "group_rating_tier"
    t.integer  "group_rating_group_number"
    t.float    "policy_total_current_payroll"
    t.float    "policy_total_standard_premium"
    t.float    "policy_total_individual_premium"
    t.float    "policy_total_group_premium"
    t.float    "policy_total_group_savings"
    t.float    "policy_group_fees"
    t.float    "policy_group_dues"
    t.float    "policy_total_costs"
    t.string   "data_source"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "final_policy_group_rating_and_premium_projections", ["policy_number", "representative_number"], name: "index_pol_prem_pol_num_and_rep", using: :btree

  create_table "group_rating_exceptions", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "representative_id"
    t.string   "exception_reason"
    t.boolean  "resolved"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "group_rating_exceptions", ["account_id"], name: "index_group_rating_exceptions_on_account_id", using: :btree
  add_index "group_rating_exceptions", ["representative_id"], name: "index_group_rating_exceptions_on_representative_id", using: :btree

  create_table "group_rating_rejections", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "representative_id"
    t.string   "reject_reason"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "program_type"
    t.boolean  "hide"
  end

  add_index "group_rating_rejections", ["account_id"], name: "index_group_rating_rejections_on_account_id", using: :btree
  add_index "group_rating_rejections", ["representative_id"], name: "index_group_rating_rejections_on_representative_id", using: :btree

  create_table "group_ratings", force: :cascade do |t|
    t.integer  "process_representative"
    t.text     "status"
    t.date     "experience_period_lower_date"
    t.date     "experience_period_upper_date"
    t.date     "current_payroll_period_lower_date"
    t.date     "current_payroll_period_upper_date"
    t.integer  "total_accounts_updated"
    t.integer  "total_policies_updated"
    t.integer  "total_manual_classes_updated"
    t.integer  "total_payrolls_updated"
    t.integer  "total_claims_updated"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "representative_id"
    t.integer  "current_payroll_year"
    t.date     "program_year_lower_date"
    t.date     "program_year_upper_date"
    t.integer  "program_year"
    t.date     "quote_year_lower_date"
    t.date     "quote_year_upper_date"
    t.integer  "quote_year"
  end

  add_index "group_ratings", ["representative_id"], name: "index_group_ratings_on_representative_id", using: :btree

  create_table "imports", force: :cascade do |t|
    t.integer  "process_representative"
    t.integer  "group_rating_id"
    t.text     "import_status"
    t.text     "parse_status"
    t.integer  "democs_count"
    t.integer  "mrcls_count"
    t.integer  "mremps_count"
    t.integer  "pcombs_count"
    t.integer  "phmgns_count"
    t.integer  "sc220s_count"
    t.integer  "sc230s_count"
    t.integer  "rates_count"
    t.integer  "pdemos_count"
    t.integer  "pemhs_count"
    t.integer  "pcovgs_count"
    t.integer  "democ_detail_records_count"
    t.integer  "mrcl_detail_records_count"
    t.integer  "mremp_employee_experience_policy_levels_count"
    t.integer  "mremp_employee_experience_manual_class_levels_count"
    t.integer  "mremp_employee_experience_claim_levels_count"
    t.integer  "pcomb_detail_records_count"
    t.integer  "phmgn_detail_records_count"
    t.integer  "sc220_rec1_employer_demographics_count"
    t.integer  "sc220_rec2_employer_manual_level_payrolls_count"
    t.integer  "sc220_rec3_employer_ar_transactions_count"
    t.integer  "sc220_rec4_policy_not_founds_count"
    t.integer  "sc230_employer_demographics_count"
    t.integer  "sc230_claim_medical_payments_count"
    t.integer  "sc230_claim_indemnity_awards_count"
    t.integer  "rate_detail_records_count"
    t.integer  "pdemo_detail_records_count"
    t.integer  "pemh_detail_records_count"
    t.integer  "pcovg_detail_records_count"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "representative_id"
    t.integer  "miras_count"
    t.integer  "mira_detail_records_count"
    t.integer  "clicds_count"
    t.integer  "clicd_detail_records_count"
  end

  add_index "imports", ["group_rating_id"], name: "index_imports_on_group_rating_id", using: :btree
  add_index "imports", ["representative_id"], name: "index_imports_on_representative_id", using: :btree

  create_table "manual_class_calculations", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "policy_calculation_id"
    t.integer  "policy_number"
    t.string   "manual_class_type"
    t.integer  "manual_number"
    t.float    "manual_class_four_year_period_payroll"
    t.float    "manual_class_expected_loss_rate"
    t.float    "manual_class_base_rate"
    t.float    "manual_class_expected_losses"
    t.integer  "manual_class_industry_group"
    t.float    "manual_class_limited_loss_rate"
    t.float    "manual_class_limited_losses"
    t.float    "manual_class_industry_group_premium_total"
    t.float    "manual_class_current_estimated_payroll"
    t.float    "manual_class_industry_group_premium_percentage"
    t.float    "manual_class_modification_rate"
    t.float    "manual_class_individual_total_rate"
    t.float    "manual_class_group_total_rate"
    t.float    "manual_class_standard_premium"
    t.float    "manual_class_estimated_group_premium"
    t.float    "manual_class_estimated_individual_premium"
    t.string   "data_source"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "manual_class_calculations", ["policy_calculation_id"], name: "index_manual_class_calculations_on_policy_calculation_id", using: :btree
  add_index "manual_class_calculations", ["policy_number", "manual_number"], name: "index_man_class_calc_pol_num_and_man_num", using: :btree

  create_table "mira_detail_records", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "record_type"
    t.integer  "requestor_number"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.string   "valid_policy_number"
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.string   "claim_indicator"
    t.string   "claim_number"
    t.date     "claim_injury_date"
    t.date     "claim_filing_date"
    t.date     "claim_hire_date"
    t.string   "gender"
    t.string   "marital_status"
    t.string   "injured_worked_represented"
    t.string   "claim_status"
    t.date     "claim_status_effective_date"
    t.string   "claimant_name"
    t.integer  "claim_manual_number"
    t.integer  "claim_sub_manual_number"
    t.integer  "industry_code"
    t.integer  "claim_type"
    t.date     "claimant_date_of_birth"
    t.string   "claimant_age_at_injury"
    t.date     "claimant_date_of_death"
    t.string   "claim_activity_status"
    t.date     "claim_activity_status_effective_date"
    t.string   "prediction_status"
    t.date     "prediction_close_status_effective_date"
    t.string   "claimant_zip_code"
    t.string   "catastrophic_claim"
    t.float    "icd1_code"
    t.string   "icd1_code_type",                                         default: "P"
    t.float    "icd2_code"
    t.string   "icd2_code_type",                                         default: "S"
    t.float    "icd3_code"
    t.string   "icd3_code_type",                                         default: "T"
    t.float    "average_weekly_wage"
    t.float    "claim_handicap_percent"
    t.date     "claim_handicap_percent_effective_date"
    t.string   "chiropractor"
    t.string   "physical_therapy"
    t.string   "salary_continuation"
    t.date     "last_date_worked"
    t.date     "estimated_return_to_work_date"
    t.date     "return_to_work_date"
    t.date     "mmi_date"
    t.date     "last_medical_date_of_service"
    t.date     "last_indemnity_period_end_date"
    t.string   "injury_or_litigation_type"
    t.float    "medical_ambulance_payments"
    t.float    "medical_clinic_or_nursing_home_payments"
    t.float    "medical_court_cost_payments"
    t.float    "medical_doctors_payments"
    t.float    "medical_drug_and_pharmacy_payments"
    t.float    "medical_emergency_room_payments"
    t.float    "medical_funeral_payments"
    t.float    "medical_hospital_payments"
    t.float    "medical_medical_device_payments"
    t.float    "medical_misc_payments"
    t.float    "medical_nursing_services_payments"
    t.float    "medical_prostheses_device_payments"
    t.float    "medical_prostheses_exam_payments"
    t.float    "medical_travel_payments"
    t.float    "medical_x_rays_and_radiology_payments"
    t.float    "total_medical_paid"
    t.string   "medical_reserve_prediction"
    t.float    "total_medical_reserve_amount"
    t.float    "indemnity_change_of_occupation_payments"
    t.string   "indemnity_change_of_occupation_reserve_prediction"
    t.float    "indemnity_change_of_occupation_reserve_amount"
    t.float    "indemnity_death_benefit_payments"
    t.string   "indemnity_death_benefit_reserve_prediction"
    t.float    "indemnity_death_benefit_reserve_amount"
    t.float    "indemnity_facial_disfigurement_payments"
    t.string   "indemnity_facial_disfigurement_reserve_prediction"
    t.float    "indemnity_facial_disfigurement_reserve_amount"
    t.float    "indemnity_living_maintenance_payments"
    t.float    "indemnity_living_maintenance_wage_loss_payments"
    t.string   "indemnity_living_maintenance_reserve_prediction"
    t.float    "indemnity_living_maintenance_reserve_amount"
    t.float    "indemnity_permanent_partial_payments"
    t.float    "indemnity_percent_permanent_partial_payments"
    t.string   "indemnity_percent_permanent_partial_reserve_prediction"
    t.float    "indemnity_percent_permanent_partial_reserve_amount"
    t.float    "indemnity_ptd_payments"
    t.string   "indemnity_ptd_reserve_prediction"
    t.float    "indemnity_ptd_reserve_amount"
    t.float    "temporary_total_payments"
    t.float    "temporary_partial_payments"
    t.float    "wage_loss_payments"
    t.string   "indemnity_temporary_total_reserve_prediction"
    t.float    "indemnity_temporary_total_reserve_amount"
    t.float    "indemnity_lump_sum_settlement_payments"
    t.float    "indemnity_attorney_fee_payments"
    t.float    "indemnity_other_benefit_payments"
    t.float    "total_indemnity_paid_amount"
    t.float    "total_original_reserve_amount"
    t.float    "reduction_amount"
    t.float    "total_reserve_amount_for_rates"
    t.string   "reduction_reason"
    t.float    "total_indemnity_reserve_amount"
  end

  create_table "miras", force: :cascade do |t|
    t.string "single_rec"
  end

  create_table "mrcl_detail_records", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "representative_type"
    t.integer  "record_type"
    t.integer  "requestor_number"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.string   "valid_policy_number"
    t.string   "manual_reclassifications"
    t.integer  "re_classed_from_manual_number"
    t.integer  "re_classed_to_manual_number"
    t.string   "reclass_manual_coverage_type"
    t.date     "reclass_creation_date"
    t.string   "reclassed_payroll_information"
    t.date     "payroll_reporting_period_from_date"
    t.date     "payroll_reporting_period_to_date"
    t.float    "re_classed_to_manual_payroll_total"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mrcls", force: :cascade do |t|
    t.string "single_rec"
  end

  create_table "mremp_employee_experience_claim_levels", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "representative_type"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.integer  "record_type"
    t.integer  "manual_number"
    t.string   "sub_manual_number"
    t.string   "claim_reserve_code"
    t.string   "claim_number"
    t.date     "injury_date"
    t.integer  "claim_indemnity_paid_using_mira_rules"
    t.integer  "claim_indemnity_mira_reserve"
    t.integer  "claim_medical_paid"
    t.integer  "claim_medical_reserve"
    t.integer  "claim_indemnity_handicap_paid_using_mira_rules"
    t.integer  "claim_indemnity_handicap_mira_reserve"
    t.integer  "claim_medical_handicap_paid"
    t.integer  "claim_medical_handicap_reserve"
    t.string   "claim_surplus_type"
    t.string   "claim_handicap_percent"
    t.string   "claim_over_policy_max_value_indicator"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "mremp_employee_experience_manual_class_levels", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "representative_type"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.integer  "record_type"
    t.integer  "manual_number"
    t.string   "sub_manual_number"
    t.string   "claim_reserve_code"
    t.string   "claim_number"
    t.integer  "experience_period_payroll"
    t.float    "manual_class_base_rate"
    t.float    "manual_class_expected_loss_rate"
    t.integer  "manual_class_expected_losses"
    t.string   "merit_rated_flag"
    t.string   "policy_manual_status"
    t.float    "limited_loss_ratio"
    t.integer  "limited_losses"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "mremp_employee_experience_policy_levels", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "representative_type"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.integer  "record_type"
    t.integer  "manual_number"
    t.string   "sub_manual_number"
    t.string   "claim_reserve_code"
    t.string   "claim_number"
    t.string   "federal_id"
    t.integer  "grand_total_modified_losses"
    t.integer  "grand_total_expected_losses"
    t.integer  "grand_total_limited_losses"
    t.integer  "policy_maximum_claim_size"
    t.float    "policy_credibility"
    t.float    "policy_experience_modifier_percent"
    t.string   "employer_name"
    t.string   "doing_business_as_name"
    t.string   "referral_name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "print_code"
    t.integer  "policy_year"
    t.date     "extract_date"
    t.date     "policy_year_exp_period_beginning_date"
    t.date     "policy_year_exp_period_ending_date"
    t.string   "green_year"
    t.string   "reserves_used_in_the_published_em"
    t.string   "risk_group_number"
    t.string   "em_capped_flag"
    t.string   "capped_em_percentage"
    t.string   "ocp_flag"
    t.string   "construction_cap_flag"
    t.float    "published_em_percentage"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "mremps", force: :cascade do |t|
    t.string "single_rec"
  end

  create_table "notes", force: :cascade do |t|
    t.text     "description"
    t.integer  "category"
    t.string   "title"
    t.string   "attachment"
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "notes", ["account_id"], name: "index_notes_on_account_id", using: :btree
  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "payroll_calculations", force: :cascade do |t|
    t.integer  "representative_number"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.string   "manual_class_type"
    t.integer  "manual_number"
    t.integer  "manual_class_calculation_id"
    t.date     "reporting_period_start_date"
    t.date     "reporting_period_end_date"
    t.float    "manual_class_payroll"
    t.string   "reporting_type"
    t.integer  "number_of_employees"
    t.integer  "policy_transferred"
    t.date     "transfer_creation_date"
    t.integer  "process_payroll_all_transactions_breakdown_by_manual_class_id"
    t.string   "payroll_origin"
    t.string   "data_source"
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.float    "manual_class_rate"
    t.integer  "manual_class_transferred"
  end

  add_index "payroll_calculations", ["manual_class_calculation_id"], name: "index_payroll_calculations_on_manual_class_calculation_id", using: :btree
  add_index "payroll_calculations", ["policy_number", "manual_number"], name: "index_payroll_calc_on_pol_num_and_man_num", using: :btree

  create_table "pcomb_detail_records", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "representative_type"
    t.integer  "record_type"
    t.integer  "requestor_number"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.string   "valid_policy_number"
    t.string   "policy_combinations"
    t.string   "predecessor_policy_type"
    t.integer  "predecessor_policy_number"
    t.string   "predecessor_filler"
    t.string   "predecessor_business_sequence_number"
    t.string   "successor_policy_type"
    t.integer  "successor_policy_number"
    t.string   "successor_filler"
    t.string   "successor_business_sequence_number"
    t.string   "transfer_type"
    t.date     "transfer_effective_date"
    t.date     "transfer_creation_date"
    t.string   "partial_transfer_due_to_labor_lease"
    t.string   "labor_lease_type"
    t.string   "partial_transfer_payroll_movement"
    t.integer  "ncci_manual_number"
    t.string   "manual_coverage_type"
    t.date     "payroll_reporting_period_from_date"
    t.date     "payroll_reporting_period_to_date"
    t.float    "manual_payroll"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "pcombs", force: :cascade do |t|
    t.string "single_rec"
  end

  create_table "pcovg_detail_records", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "record_type"
    t.integer  "requestor_number"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.string   "valid_policy_number"
    t.string   "coverage_status"
    t.date     "coverage_status_effective_date"
    t.date     "coverage_status_end_date"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "pcovgs", force: :cascade do |t|
    t.string "single_rec"
  end

  create_table "pdemo_detail_records", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "record_type"
    t.integer  "requestor_number"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.string   "valid_policy_number"
    t.string   "current_coverage_status"
    t.date     "coverage_status_effective_date"
    t.integer  "federal_identification_number"
    t.string   "business_name"
    t.string   "trading_as_name"
    t.string   "valid_mailing_address"
    t.string   "mailing_address_line_1"
    t.string   "mailing_address_line_2"
    t.string   "mailing_city"
    t.string   "mailing_state"
    t.integer  "mailing_zip_code"
    t.integer  "mailing_zip_code_plus_4"
    t.integer  "mailing_country_code"
    t.integer  "mailing_county"
    t.string   "valid_location_address"
    t.string   "location_address_line_1"
    t.string   "location_address_line_2"
    t.string   "location_city"
    t.string   "location_state"
    t.integer  "location_zip_code"
    t.integer  "location_zip_code_plus_4"
    t.integer  "location_country_code"
    t.integer  "location_county"
    t.integer  "currently_assigned_clm_representative_number"
    t.integer  "currently_assigned_risk_representative_number"
    t.integer  "currently_assigned_erc_representative_number"
    t.integer  "currently_assigned_grc_representative_number"
    t.integer  "immediate_successor_policy_number"
    t.integer  "immediate_successor_business_sequence_number"
    t.integer  "ultimate_successor_policy_number"
    t.integer  "ultimate_successor_business_sequence_number"
    t.string   "employer_type"
    t.string   "coverage_type"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "pdemos", force: :cascade do |t|
    t.string "single_rec"
  end

  create_table "pemh_detail_records", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "record_type"
    t.integer  "requestor_number"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.string   "valid_policy_number"
    t.string   "current_coverage_status"
    t.date     "coverage_status_effective_date"
    t.float    "experience_modifier_rate"
    t.date     "em_effective_date"
    t.integer  "policy_year"
    t.date     "reporting_period_start_date"
    t.date     "reporting_period_end_date"
    t.string   "group_participation_indicator"
    t.integer  "group_code"
    t.string   "group_type"
    t.string   "rrr_participation_indicator"
    t.integer  "rrr_tier"
    t.integer  "rrr_policy_claim_limit"
    t.integer  "rrr_minimum_premium_percentage"
    t.string   "deductible_participation_indicator"
    t.integer  "deductible_level"
    t.string   "deductible_stop_loss_indicator"
    t.integer  "deductible_discount_percentage"
    t.string   "ocp_participation_indicator"
    t.integer  "ocp_participation"
    t.integer  "ocp_first_year_of_participation"
    t.string   "grow_ohio_participation_indicator"
    t.string   "em_cap_participation_indicator"
    t.string   "drug_free_program_participation_indicator"
    t.string   "drug_free_program_type"
    t.string   "drug_free_program_participation_level"
    t.string   "drug_free_program_discount_eligiblity_indicator"
    t.string   "issp_participation_indicator"
    t.string   "issp_discount_eligibility_indicator"
    t.string   "twbns_participation_indicator"
    t.string   "twbns_discount_eligibility_indicator"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  create_table "pemhs", force: :cascade do |t|
    t.string "single_rec"
  end

  create_table "phmgn_detail_records", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "representative_type"
    t.integer  "record_type"
    t.integer  "requestor_number"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.string   "valid_policy_number"
    t.string   "experience_payroll_premium_information"
    t.string   "industry_code"
    t.integer  "ncci_manual_number"
    t.string   "manual_coverage_type"
    t.float    "manual_payroll"
    t.float    "manual_premium"
    t.float    "premium_percentage"
    t.integer  "upcoming_policy_year"
    t.integer  "policy_year_extracted_for_experience_payroll_determining_premiu"
    t.date     "policy_year_extracted_beginning_date"
    t.date     "policy_year_extracted_ending_date"
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
  end

  create_table "phmgns", force: :cascade do |t|
    t.string "single_rec"
  end

  create_table "policy_calculations", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "policy_number"
    t.string   "policy_group_number"
    t.float    "policy_total_four_year_payroll"
    t.integer  "policy_credibility_group"
    t.integer  "policy_maximum_claim_value"
    t.float    "policy_credibility_percent"
    t.float    "policy_total_expected_losses"
    t.float    "policy_total_limited_losses"
    t.integer  "policy_total_claims_count"
    t.float    "policy_total_modified_losses_group_reduced"
    t.float    "policy_total_modified_losses_individual_reduced"
    t.float    "policy_group_ratio"
    t.float    "policy_individual_total_modifier"
    t.float    "policy_individual_experience_modified_rate"
    t.integer  "policy_industry_group"
    t.float    "policy_total_current_payroll"
    t.float    "policy_total_standard_premium"
    t.float    "policy_total_individual_premium"
    t.integer  "currently_assigned_representative_number"
    t.string   "valid_policy_number"
    t.string   "current_coverage_status"
    t.date     "coverage_status_effective_date"
    t.date     "policy_creation_date"
    t.string   "federal_identification_number"
    t.string   "business_name"
    t.string   "trading_as_name"
    t.string   "in_care_name_contact_name"
    t.string   "valid_mailing_address"
    t.string   "mailing_address_line_1"
    t.string   "mailing_address_line_2"
    t.string   "mailing_city"
    t.string   "mailing_state"
    t.integer  "mailing_zip_code"
    t.integer  "mailing_zip_code_plus_4"
    t.integer  "mailing_country_code"
    t.integer  "mailing_county"
    t.string   "valid_location_address"
    t.string   "location_address_line_1"
    t.string   "location_address_line_2"
    t.string   "location_city"
    t.string   "location_state"
    t.integer  "location_zip_code"
    t.integer  "location_zip_code_plus_4"
    t.integer  "location_country_code"
    t.integer  "location_county"
    t.integer  "currently_assigned_clm_representative_number"
    t.integer  "currently_assigned_risk_representative_number"
    t.integer  "currently_assigned_erc_representative_number"
    t.integer  "currently_assigned_grc_representative_number"
    t.integer  "immediate_successor_policy_number"
    t.integer  "immediate_successor_business_sequence_number"
    t.integer  "ultimate_successor_policy_number"
    t.integer  "ultimate_successor_business_sequence_number"
    t.string   "employer_type"
    t.string   "coverage_type"
    t.string   "policy_coverage_type"
    t.string   "policy_employer_type"
    t.float    "merit_rate"
    t.string   "group_code"
    t.string   "minimum_premium_percentage"
    t.string   "rate_adjust_factor"
    t.date     "em_effective_date"
    t.float    "regular_balance_amount"
    t.float    "attorney_general_balance_amount"
    t.float    "appealed_balance_amount"
    t.float    "pending_balance_amount"
    t.float    "advance_deposit_amount"
    t.string   "data_source"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "representative_id"
    t.integer  "account_id"
    t.float    "policy_individual_adjusted_experience_modified_rate"
    t.float    "policy_adjusted_standard_premium"
    t.float    "policy_adjusted_individual_premium"
  end

  add_index "policy_calculations", ["account_id"], name: "index_policy_calculations_on_account_id", using: :btree
  add_index "policy_calculations", ["policy_number"], name: "index_policy_calculations_on_pol_num", using: :btree
  add_index "policy_calculations", ["representative_id"], name: "index_policy_calculations_on_representative_id", using: :btree

  create_table "policy_coverage_status_histories", force: :cascade do |t|
    t.integer  "policy_calculation_id"
    t.integer  "representative_id"
    t.integer  "representative_number"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.date     "coverage_effective_date"
    t.date     "coverage_end_date"
    t.string   "coverage_status"
    t.integer  "lapse_days"
    t.string   "data_source"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "policy_coverage_status_histories", ["policy_calculation_id"], name: "index_policy_coverage_status_histories_on_policy_calculation_id", using: :btree
  add_index "policy_coverage_status_histories", ["representative_id"], name: "index_policy_coverage_status_histories_on_representative_id", using: :btree

  create_table "policy_program_histories", force: :cascade do |t|
    t.integer  "policy_calculation_id"
    t.integer  "representative_id"
    t.integer  "representative_number"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.float    "experience_modifier_rate"
    t.date     "em_effective_date"
    t.integer  "policy_year"
    t.date     "reporting_period_start_date"
    t.date     "reporting_period_end_date"
    t.string   "group_participation_indicator"
    t.integer  "group_code"
    t.string   "group_type"
    t.string   "rrr_participation_indicator"
    t.integer  "rrr_tier"
    t.integer  "rrr_policy_claim_limit"
    t.integer  "rrr_minimum_premium_percentage"
    t.string   "deductible_participation_indicator"
    t.integer  "deductible_level"
    t.string   "deductible_stop_loss_indicator"
    t.integer  "deductible_discount_percentage"
    t.string   "ocp_participation_indicator"
    t.integer  "ocp_participation"
    t.integer  "ocp_first_year_of_participation"
    t.string   "grow_ohio_participation_indicator"
    t.string   "em_cap_participation_indicator"
    t.string   "drug_free_program_participation_indicator"
    t.string   "drug_free_program_type"
    t.string   "drug_free_program_participation_level"
    t.string   "drug_free_program_discount_eligiblity_indicator"
    t.string   "issp_participation_indicator"
    t.string   "issp_discount_eligibility_indicator"
    t.string   "twbns_participation_indicator"
    t.string   "twbns_discount_eligibility_indicator"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "policy_program_histories", ["policy_calculation_id"], name: "index_policy_program_histories_on_policy_calculation_id", using: :btree
  add_index "policy_program_histories", ["representative_id"], name: "index_policy_program_histories_on_representative_id", using: :btree

  create_table "process_manual_class_four_year_payroll_with_conditions", force: :cascade do |t|
    t.integer  "representative_number"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "manual_number"
    t.string   "manual_class_type"
    t.float    "manual_class_four_year_period_payroll"
    t.string   "data_source"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "process_manual_class_four_year_payroll_without_conditions", id: false, force: :cascade do |t|
    t.integer  "representative_number"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "manual_number"
    t.string   "manual_class_type"
    t.float    "manual_class_four_year_period_payroll"
    t.string   "data_source"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "process_manual_reclass_tables", force: :cascade do |t|
    t.integer  "representative_number"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "re_classed_from_manual_number"
    t.integer  "re_classed_to_manual_number"
    t.string   "reclass_manual_coverage_type"
    t.date     "reclass_creation_date"
    t.date     "payroll_reporting_period_from_date"
    t.date     "payroll_reporting_period_to_date"
    t.float    "re_classed_to_manual_payroll_total"
    t.string   "payroll_origin"
    t.string   "data_source"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "process_payroll_all_transactions_breakdown_by_manual_classes", force: :cascade do |t|
    t.integer  "representative_number"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.date     "policy_status_effective_date"
    t.string   "policy_status"
    t.integer  "manual_number"
    t.string   "manual_class_type"
    t.string   "manual_class_description"
    t.integer  "bwc_customer_id"
    t.date     "reporting_period_start_date"
    t.date     "reporting_period_end_date"
    t.float    "manual_class_rate"
    t.float    "manual_class_payroll"
    t.string   "reporting_type"
    t.integer  "number_of_employees"
    t.integer  "policy_transferred"
    t.date     "transfer_creation_date"
    t.string   "payroll_origin"
    t.string   "data_source"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "manual_class_transferred"
  end

  add_index "process_payroll_all_transactions_breakdown_by_manual_classes", ["policy_number", "manual_number", "representative_number"], name: "index_pr_pol_num_and_man_num_rep", using: :btree

  create_table "process_payroll_breakdown_by_manual_classes", force: :cascade do |t|
    t.integer  "representative_number"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.date     "policy_status_effective_date"
    t.string   "policy_status"
    t.integer  "manual_number"
    t.string   "manual_class_type"
    t.string   "manual_class_description"
    t.integer  "bwc_customer_id"
    t.date     "reporting_period_start_date"
    t.date     "reporting_period_end_date"
    t.float    "manual_class_rate"
    t.float    "manual_class_payroll"
    t.string   "reporting_type"
    t.integer  "number_of_employees"
    t.string   "payroll_origin"
    t.string   "data_source"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "manual_class_transferred"
  end

  add_index "process_payroll_breakdown_by_manual_classes", ["policy_number", "manual_number", "representative_number"], name: "index_proc_pr_by_man_cl_on_pol_and_man_rep", using: :btree

  create_table "process_policy_combination_lease_terminations", force: :cascade do |t|
    t.integer  "representative_number"
    t.string   "valid_policy_number"
    t.string   "policy_combinations"
    t.string   "predecessor_policy_type"
    t.integer  "predecessor_policy_number"
    t.string   "successor_policy_type"
    t.integer  "successor_policy_number"
    t.string   "transfer_type"
    t.date     "transfer_effective_date"
    t.date     "transfer_creation_date"
    t.string   "partial_transfer_due_to_labor_lease"
    t.string   "labor_lease_type"
    t.string   "partial_transfer_payroll_movement"
    t.integer  "ncci_manual_number"
    t.string   "manual_coverage_type"
    t.date     "payroll_reporting_period_from_date"
    t.date     "payroll_reporting_period_to_date"
    t.float    "manual_payroll"
    t.string   "payroll_origin"
    t.string   "data_source"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "process_policy_combine_full_transfers", force: :cascade do |t|
    t.integer  "representative_number"
    t.string   "policy_type"
    t.integer  "manual_number"
    t.string   "manual_class_type"
    t.date     "reporting_period_start_date"
    t.date     "reporting_period_end_date"
    t.float    "manual_class_rate"
    t.float    "manual_class_payroll"
    t.float    "manual_class_premium"
    t.string   "predecessor_policy_type"
    t.integer  "predecessor_policy_number"
    t.string   "successor_policy_type"
    t.integer  "successor_policy_number"
    t.string   "transfer_type"
    t.date     "transfer_effective_date"
    t.date     "transfer_creation_date"
    t.string   "payroll_origin"
    t.string   "data_source"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "process_policy_combine_partial_to_full_leases", force: :cascade do |t|
    t.integer  "representative_number"
    t.string   "valid_policy_number"
    t.string   "policy_combinations"
    t.string   "predecessor_policy_type"
    t.integer  "predecessor_policy_number"
    t.string   "successor_policy_type"
    t.integer  "successor_policy_number"
    t.string   "transfer_type"
    t.date     "transfer_effective_date"
    t.date     "transfer_creation_date"
    t.string   "partial_transfer_due_to_labor_lease"
    t.string   "labor_lease_type"
    t.string   "partial_transfer_payroll_movement"
    t.integer  "ncci_manual_number"
    t.string   "manual_coverage_type"
    t.date     "payroll_reporting_period_from_date"
    t.date     "payroll_reporting_period_to_date"
    t.float    "manual_payroll"
    t.string   "payroll_origin"
    t.string   "data_source"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "process_policy_combine_partial_transfer_no_leases", force: :cascade do |t|
    t.integer  "representative_number"
    t.string   "valid_policy_number"
    t.string   "policy_combinations"
    t.string   "predecessor_policy_type"
    t.integer  "predecessor_policy_number"
    t.string   "successor_policy_type"
    t.integer  "successor_policy_number"
    t.string   "transfer_type"
    t.date     "transfer_effective_date"
    t.date     "transfer_creation_date"
    t.string   "partial_transfer_due_to_labor_lease"
    t.string   "labor_lease_type"
    t.string   "partial_transfer_payroll_movement"
    t.integer  "ncci_manual_number"
    t.string   "manual_coverage_type"
    t.date     "payroll_reporting_period_from_date"
    t.date     "payroll_reporting_period_to_date"
    t.float    "manual_payroll"
    t.string   "payroll_origin"
    t.string   "data_source"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "process_policy_coverage_status_histories", force: :cascade do |t|
    t.integer  "representative_number"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.date     "coverage_effective_date"
    t.date     "coverage_end_date"
    t.string   "coverage_status"
    t.integer  "lapse_days"
    t.string   "data_source"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "process_policy_coverage_status_histories", ["policy_number"], name: "index_process_policy_coverage_status_histories_on_policy_number", using: :btree

  create_table "process_policy_experience_period_peos", force: :cascade do |t|
    t.integer  "representative_number"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.date     "manual_class_sf_peo_lease_effective_date"
    t.date     "manual_class_sf_peo_lease_termination_date"
    t.date     "manual_class_si_peo_lease_effective_date"
    t.date     "manual_class_si_peo_lease_termination_date"
    t.string   "data_source"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "process_policy_experience_period_peos", ["policy_number"], name: "index_process_policy_experience_period_peos_on_policy_number", using: :btree

  create_table "quotes", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "program_type"
    t.integer  "status"
    t.float    "fees"
    t.string   "invoice_number"
    t.string   "quote_generated"
    t.date     "quote_date"
    t.date     "effective_start_date"
    t.date     "effective_end_date"
    t.date     "ac2_signed_on"
    t.date     "ac26_signed_on"
    t.date     "u153_signed_on"
    t.date     "contract_signed_on"
    t.date     "questionnaire_signed_on"
    t.date     "invoice_signed_on"
    t.string   "group_code"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "questionnaire_question_1"
    t.boolean  "questionnaire_question_2"
    t.boolean  "questionnaire_question_3"
    t.boolean  "questionnaire_question_4"
    t.boolean  "questionnaire_question_5"
    t.string   "quote"
    t.float    "quote_tier"
    t.date     "experience_period_lower_date"
    t.date     "experience_period_upper_date"
    t.date     "current_payroll_period_lower_date"
    t.date     "current_payroll_period_upper_date"
    t.integer  "current_payroll_year"
    t.date     "program_year_lower_date"
    t.date     "program_year_upper_date"
    t.integer  "program_year"
    t.date     "quote_year_lower_date"
    t.date     "quote_year_upper_date"
    t.integer  "quote_year"
    t.float    "paid_amount"
    t.string   "check_number"
    t.boolean  "questionnaire_question_6"
    t.string   "updated_by"
    t.string   "created_by"
    t.date     "paid_date"
  end

  add_index "quotes", ["account_id"], name: "index_quotes_on_account_id", using: :btree

  create_table "rate_detail_records", force: :cascade do |t|
    t.date     "create_date"
    t.integer  "representative_number"
    t.string   "representative_name"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.string   "policy_name"
    t.integer  "tax_id"
    t.date     "policy_status_effective_date"
    t.string   "policy_status"
    t.date     "reporting_period_start_date"
    t.date     "reporting_period_end_date"
    t.integer  "manual_class"
    t.string   "manual_class_type"
    t.string   "manual_class_description"
    t.integer  "bwc_customer_id"
    t.string   "individual_first_name"
    t.string   "individual_middle_name"
    t.string   "individual_last_name"
    t.integer  "individual_tax_id"
    t.float    "manual_class_rate"
    t.string   "reporting_type"
    t.integer  "number_of_employees"
    t.float    "payroll"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "rates", force: :cascade do |t|
    t.string "single_rec"
  end

  create_table "representatives", force: :cascade do |t|
    t.integer  "representative_number"
    t.string   "company_name"
    t.string   "abbreviated_name"
    t.string   "group_fees"
    t.string   "group_dues"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "logo"
    t.string   "zip_file"
    t.date     "experience_period_lower_date"
    t.date     "experience_period_upper_date"
    t.date     "current_payroll_period_lower_date"
    t.date     "current_payroll_period_upper_date"
    t.integer  "current_payroll_year"
    t.date     "program_year_lower_date"
    t.date     "program_year_upper_date"
    t.integer  "program_year"
    t.date     "quote_year_lower_date"
    t.date     "quote_year_upper_date"
    t.integer  "quote_year"
    t.string   "location_address_1"
    t.string   "location_address_2"
    t.string   "location_city"
    t.string   "location_state"
    t.string   "location_zip_code"
    t.string   "mailing_address_1"
    t.string   "mailing_address_2"
    t.string   "mailing_city"
    t.string   "mailing_state"
    t.string   "mailing_zip_code"
    t.string   "phone_number"
    t.string   "toll_free_number"
    t.string   "fax_number"
    t.string   "email_address"
    t.string   "president_first_name"
    t.string   "president_last_name"
  end

  create_table "representatives_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "representative_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "representatives_users", ["representative_id"], name: "index_representatives_users_on_representative_id", using: :btree
  add_index "representatives_users", ["user_id"], name: "index_representatives_users_on_user_id", using: :btree

  create_table "sc220_rec1_employer_demographics", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "representative_type"
    t.string   "description_ar"
    t.integer  "record_type"
    t.integer  "request_type"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.string   "federal_identification_number"
    t.string   "business_name"
    t.string   "trading_as_name"
    t.string   "in_care_name_contact_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "zip_code_plus_4"
    t.string   "country_code"
    t.string   "county"
    t.integer  "currently_assigned_representative_number"
    t.string   "currently_assigned_representative_type"
    t.integer  "successor_policy_number"
    t.integer  "successor_business_sequence_number"
    t.float    "merit_rate"
    t.string   "group_code"
    t.string   "minimum_premium_percentage"
    t.string   "rate_adjust_factor"
    t.date     "em_effective_date"
    t.float    "n2nd_merit_rate"
    t.string   "n2nd_group_code"
    t.string   "n2nd_minimum_premium_percentage"
    t.string   "n2nd_rate_adjust_factor"
    t.date     "n2nd_em_effective_date"
    t.float    "n3rd_merit_rate"
    t.string   "n3rd_group_code"
    t.string   "n3rd_minimum_premium_percentage"
    t.string   "n3rd_rate_adjust_factor"
    t.date     "n3rd_em_effective_date"
    t.float    "n4th_merit_rate"
    t.string   "n4th_group_code"
    t.string   "n4th_minimum_premium_percentage"
    t.string   "n4th_rate_adjust_factor"
    t.date     "n4th_em_effective_date"
    t.float    "n5th_merit_rate"
    t.string   "n5th_group_code"
    t.string   "n5th_minimum_premium_percentage"
    t.string   "n5th_rate_adjust_factor"
    t.date     "n5th_em_effective_date"
    t.float    "n6th_merit_rate"
    t.string   "n6th_group_code"
    t.string   "n6th_minimum_premium_percentage"
    t.string   "n6th_rate_adjust_factor"
    t.date     "n6th_em_effective_date"
    t.float    "n7th_merit_rate"
    t.string   "n7th_group_code"
    t.string   "n7th_minimum_premium_percentage"
    t.string   "n7th_rate_adjust_factor"
    t.date     "n7th_em_effective_date"
    t.float    "n8th_merit_rate"
    t.string   "n8th_group_code"
    t.string   "n8th_minimum_premium_percentage"
    t.string   "n8th_rate_adjust_factor"
    t.date     "n8th_em_effective_date"
    t.float    "n9th_merit_rate"
    t.string   "n9th_group_code"
    t.string   "n9th_minimum_premium_percentage"
    t.string   "n9th_rate_adjust_factor"
    t.date     "n9th_em_effective_date"
    t.float    "n10th_merit_rate"
    t.string   "n10th_group_code"
    t.string   "n10th_minimum_premium_percentage"
    t.string   "n10th_rate_adjust_factor"
    t.date     "n10th_em_effective_date"
    t.float    "n11th_merit_rate"
    t.string   "n11th_group_code"
    t.string   "n11th_minimum_premium_percentage"
    t.string   "n11th_rate_adjust_factor"
    t.date     "n11th_em_effective_date"
    t.float    "n12th_merit_rate"
    t.string   "n12th_group_code"
    t.string   "n12th_minimum_premium_percentage"
    t.string   "n12th_rate_adjust_factor"
    t.date     "n12th_em_effective_date"
    t.string   "coverage_status"
    t.date     "coverage_effective_date"
    t.date     "coverage_end_date"
    t.string   "n2nd_coverage_status"
    t.date     "n2nd_coverage_effective_date"
    t.date     "n2nd_coverage_end_date"
    t.string   "n3rd_coverage_status"
    t.date     "n3rd_coverage_effective_date"
    t.date     "n3rd_coverage_end_date"
    t.string   "n4th_coverage_status"
    t.date     "n4th_coverage_effective_date"
    t.date     "n4th_coverage_end_date"
    t.string   "n5th_coverage_status"
    t.date     "n5th_coverage_effective_date"
    t.date     "n5th_coverage_end_date"
    t.string   "n6th_coverage_status"
    t.date     "n6th_coverage_effective_date"
    t.date     "n6th_coverage_end_date"
    t.float    "regular_balance_amount"
    t.float    "attorney_general_balance_amount"
    t.float    "appealed_balance_amount"
    t.float    "pending_balance_amount"
    t.float    "advance_deposit_amount"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "sc220_rec2_employer_manual_level_payrolls", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "representative_type"
    t.string   "description_ar"
    t.integer  "record_type"
    t.integer  "request_type"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.integer  "manual_number"
    t.string   "manual_type"
    t.float    "year_to_date_payroll"
    t.float    "manual_class_rate"
    t.float    "year_to_date_premium_billed"
    t.date     "manual_effective_date"
    t.float    "n2nd_year_to_date_payroll"
    t.float    "n2nd_manual_class_rate"
    t.float    "n2nd_year_to_date_premium_billed"
    t.date     "n2nd_manual_effective_date"
    t.float    "n3rd_year_to_date_payroll"
    t.float    "n3rd_manual_class_rate"
    t.float    "n3rd_year_to_date_premium_billed"
    t.date     "n3rd_manual_effective_date"
    t.float    "n4th_year_to_date_payroll"
    t.float    "n4th_manual_class_rate"
    t.float    "n4th_year_to_date_premium_billed"
    t.date     "n4th_manual_effective_date"
    t.float    "n5th_year_to_date_payroll"
    t.float    "n5th_manual_class_rate"
    t.float    "n5th_year_to_date_premium_billed"
    t.date     "n5th_manual_effective_date"
    t.float    "n6th_year_to_date_payroll"
    t.float    "n6th_manual_class_rate"
    t.float    "n6th_year_to_date_premium_billed"
    t.date     "n6th_manual_effective_date"
    t.float    "n7th_year_to_date_payroll"
    t.float    "n7th_manual_class_rate"
    t.float    "n7th_year_to_date_premium_billed"
    t.date     "n7th_manual_effective_date"
    t.float    "n8th_year_to_date_payroll"
    t.float    "n8th_manual_class_rate"
    t.float    "n8th_year_to_date_premium_billed"
    t.date     "n8th_manual_effective_date"
    t.float    "n9th_year_to_date_payroll"
    t.float    "n9th_manual_class_rate"
    t.float    "n9th_year_to_date_premium_billed"
    t.date     "n9th_manual_effective_date"
    t.float    "n10th_year_to_date_payroll"
    t.float    "n10th_manual_class_rate"
    t.float    "n10th_year_to_date_premium_billed"
    t.date     "n10th_manual_effective_date"
    t.float    "n11th_year_to_date_payroll"
    t.float    "n11th_manual_class_rate"
    t.float    "n11th_year_to_date_premium_billed"
    t.date     "n11th_manual_effective_date"
    t.float    "n12th_year_to_date_payroll"
    t.float    "n12th_manual_class_rate"
    t.float    "n12th_year_to_date_premium_billed"
    t.date     "n12th_manual_effective_date"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "sc220_rec3_employer_ar_transactions", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "representative_type"
    t.string   "descriptionar"
    t.integer  "record_type"
    t.integer  "request_type"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.date     "trans_date"
    t.string   "invoice_number"
    t.string   "billing_trans_status_code"
    t.float    "trans_amount"
    t.string   "trans_type"
    t.float    "paid_amount"
    t.date     "n2nd_trans_date"
    t.string   "n2nd_invoice_number"
    t.string   "n2nd_billing_trans_status_code"
    t.float    "n2nd_trans_amount"
    t.string   "n2nd_trans_type"
    t.float    "n2nd_paid_amount"
    t.date     "n3rd_trans_date"
    t.string   "n3rd_invoice_number"
    t.string   "n3rd_billing_trans_status_code"
    t.float    "n3rd_trans_amount"
    t.string   "n3rd_trans_type"
    t.float    "n3rd_paid_amount"
    t.date     "n4th_trans_date"
    t.string   "n4th_invoice_number"
    t.string   "n4th_billing_trans_status_code"
    t.float    "n4th_trans_amount"
    t.string   "n4th_trans_type"
    t.float    "n4th_paid_amount"
    t.date     "n5th_trans_date"
    t.string   "n5th_invoice_number"
    t.string   "n5th_billing_trans_status_code"
    t.float    "n5th_trans_amount"
    t.string   "n5th_trans_type"
    t.float    "n5th_paid_amount"
    t.date     "n6th_trans_date"
    t.string   "n6th_invoice_number"
    t.string   "n6th_billing_trans_status_code"
    t.float    "n6th_trans_amount"
    t.string   "n6th_trans_type"
    t.float    "n6th_paid_amount"
    t.date     "n7th_trans_date"
    t.string   "n7th_invoice_number"
    t.string   "n7th_billing_trans_status_code"
    t.float    "n7th_trans_amount"
    t.string   "n7th_trans_type"
    t.float    "n7th_paid_amount"
    t.date     "n8th_trans_date"
    t.string   "n8th_invoice_number"
    t.string   "n8th_billing_trans_status_code"
    t.float    "n8th_trans_amount"
    t.string   "n8th_trans_type"
    t.float    "n8th_paid_amount"
    t.date     "n9th_trans_date"
    t.string   "n9th_invoice_number"
    t.string   "n9th_billing_trans_status_code"
    t.float    "n9th_trans_amount"
    t.string   "n9th_trans_type"
    t.float    "n9th_paid_amount"
    t.date     "n10th_trans_date"
    t.string   "n10th_invoice_number"
    t.string   "n10th_billing_trans_status_code"
    t.float    "n10th_trans_amount"
    t.string   "n10th_trans_type"
    t.float    "n10th_paid_amount"
    t.date     "n11th_trans_date"
    t.string   "n11th_invoice_number"
    t.string   "n11th_billing_trans_status_code"
    t.float    "n11th_trans_amount"
    t.string   "n11th_trans_type"
    t.float    "n11th_paid_amount"
    t.date     "n12th_trans_date"
    t.string   "n12th_invoice_number"
    t.string   "n12th_billing_trans_status_code"
    t.float    "n12th_trans_amount"
    t.string   "n12th_trans_type"
    t.float    "n12th_paid_amount"
    t.date     "n13th_trans_date"
    t.string   "n13th_invoice_number"
    t.string   "n13th_billing_trans_status_code"
    t.float    "n13th_trans_amount"
    t.string   "n13th_trans_type"
    t.float    "n13th_paid_amount"
    t.date     "n14th_trans_date"
    t.string   "n14th_invoice_number"
    t.string   "n14th_billing_trans_status_code"
    t.float    "n14th_trans_amount"
    t.string   "n14th_trans_type"
    t.float    "n14th_paid_amount"
    t.date     "n15th_trans_date"
    t.string   "n15th_invoice_number"
    t.string   "n15th_billing_trans_status_code"
    t.float    "n15th_trans_amount"
    t.string   "n15th_trans_type"
    t.float    "n15th_paid_amount"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "sc220_rec4_policy_not_founds", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "representative_type"
    t.string   "description"
    t.integer  "record_type"
    t.integer  "request_type"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.string   "error_message"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "sc220s", force: :cascade do |t|
    t.string "single_rec"
  end

  create_table "sc230_claim_indemnity_awards", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "representative_type"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.integer  "claim_manual_number"
    t.string   "record_type"
    t.string   "claim_number"
    t.date     "hearing_date"
    t.date     "injury_date"
    t.date     "from_date"
    t.date     "to_date"
    t.string   "award_type"
    t.string   "number_of_weeks"
    t.float    "awarded_weekly_rate"
    t.float    "award_amount"
    t.integer  "payment_amount"
    t.string   "claimant_name"
    t.string   "payee_name"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "sc230_claim_medical_payments", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "representative_type"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.integer  "claim_manual_number"
    t.string   "record_type"
    t.string   "claim_number"
    t.date     "hearing_date"
    t.date     "injury_date"
    t.string   "from_date"
    t.string   "to_date"
    t.string   "award_type"
    t.string   "number_of_weeks"
    t.string   "awarded_weekly_rate"
    t.integer  "award_amount"
    t.float    "payment_amount"
    t.string   "claimant_name"
    t.string   "payee_name"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "sc230_employer_demographics", force: :cascade do |t|
    t.integer  "representative_number"
    t.integer  "representative_type"
    t.string   "policy_type"
    t.integer  "policy_number"
    t.integer  "business_sequence_number"
    t.integer  "claim_manual_number"
    t.string   "record_type"
    t.string   "claim_number"
    t.string   "policy_name"
    t.string   "doing_business_as_name"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.integer  "zip_code"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "sc230s", force: :cascade do |t|
    t.string "single_rec"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "role",                   default: 2
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.json     "object"
    t.json     "object_changes"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "account_programs", "accounts"
  add_foreign_key "accounts", "representatives"
  add_foreign_key "accounts_affiliates", "accounts"
  add_foreign_key "accounts_affiliates", "affiliates"
  add_foreign_key "accounts_contacts", "accounts"
  add_foreign_key "accounts_contacts", "contacts"
  add_foreign_key "accounts_contacts_contact_types", "accounts_contacts"
  add_foreign_key "accounts_contacts_contact_types", "contact_types"
  add_foreign_key "affiliates", "representatives"
  add_foreign_key "claim_calculations", "policy_calculations"
  add_foreign_key "group_rating_exceptions", "accounts"
  add_foreign_key "group_rating_exceptions", "representatives"
  add_foreign_key "group_rating_rejections", "accounts"
  add_foreign_key "group_rating_rejections", "representatives"
  add_foreign_key "group_ratings", "representatives"
  add_foreign_key "imports", "group_ratings"
  add_foreign_key "imports", "representatives"
  add_foreign_key "manual_class_calculations", "policy_calculations"
  add_foreign_key "notes", "accounts"
  add_foreign_key "notes", "users"
  add_foreign_key "payroll_calculations", "manual_class_calculations"
  add_foreign_key "policy_calculations", "accounts"
  add_foreign_key "policy_calculations", "representatives"
  add_foreign_key "policy_coverage_status_histories", "policy_calculations"
  add_foreign_key "policy_coverage_status_histories", "representatives"
  add_foreign_key "policy_program_histories", "policy_calculations"
  add_foreign_key "policy_program_histories", "representatives"
  add_foreign_key "quotes", "accounts"
  add_foreign_key "representatives_users", "representatives"
  add_foreign_key "representatives_users", "users"
end
