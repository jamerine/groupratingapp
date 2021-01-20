# == Schema Information
#
# Table name: policy_calculations
#
#  id                                                  :integer          not null, primary key
#  advance_deposit_amount                              :float
#  appealed_balance_amount                             :float
#  attorney_general_balance_amount                     :float
#  business_name                                       :string
#  coverage_status_effective_date                      :date
#  coverage_type                                       :string
#  current_coverage_status                             :string
#  currently_assigned_clm_representative_number        :integer
#  currently_assigned_erc_representative_number        :integer
#  currently_assigned_grc_representative_number        :integer
#  currently_assigned_representative_number            :integer
#  currently_assigned_risk_representative_number       :integer
#  data_source                                         :string
#  em_effective_date                                   :date
#  employer_type                                       :string
#  federal_identification_number                       :string
#  group_code                                          :string
#  immediate_successor_business_sequence_number        :integer
#  immediate_successor_policy_number                   :integer
#  in_care_name_contact_name                           :string
#  location_address_line_1                             :string
#  location_address_line_2                             :string
#  location_city                                       :string
#  location_country_code                               :integer
#  location_county                                     :integer
#  location_state                                      :string
#  location_zip_code                                   :integer
#  location_zip_code_plus_4                            :integer
#  mailing_address_line_1                              :string
#  mailing_address_line_2                              :string
#  mailing_city                                        :string
#  mailing_country_code                                :integer
#  mailing_county                                      :integer
#  mailing_state                                       :string
#  mailing_zip_code                                    :integer
#  mailing_zip_code_plus_4                             :integer
#  merit_rate                                          :float
#  minimum_premium_percentage                          :string
#  pending_balance_amount                              :float
#  policy_adjusted_individual_premium                  :float
#  policy_adjusted_standard_premium                    :float
#  policy_coverage_type                                :string
#  policy_creation_date                                :date
#  policy_credibility_group                            :integer
#  policy_credibility_percent                          :float
#  policy_employer_type                                :string
#  policy_group_number                                 :string
#  policy_group_ratio                                  :float
#  policy_individual_adjusted_experience_modified_rate :float
#  policy_individual_experience_modified_rate          :float
#  policy_individual_total_modifier                    :float
#  policy_industry_group                               :integer
#  policy_maximum_claim_value                          :integer
#  policy_number                                       :integer
#  policy_total_claims_count                           :integer
#  policy_total_current_payroll                        :float
#  policy_total_expected_losses                        :float
#  policy_total_four_year_payroll                      :float
#  policy_total_individual_premium                     :float
#  policy_total_limited_losses                         :float
#  policy_total_modified_losses_group_reduced          :float
#  policy_total_modified_losses_individual_reduced     :float
#  policy_total_standard_premium                       :float
#  rate_adjust_factor                                  :string
#  regular_balance_amount                              :float
#  representative_number                               :integer
#  trading_as_name                                     :string
#  ultimate_successor_business_sequence_number         :integer
#  ultimate_successor_policy_number                    :integer
#  valid_location_address                              :string
#  valid_mailing_address                               :string
#  valid_policy_number                                 :string
#  created_at                                          :datetime         not null
#  updated_at                                          :datetime         not null
#  account_id                                          :integer
#  representative_id                                   :integer
#
# Indexes
#
#  index_policy_calculations_on_account_id         (account_id)
#  index_policy_calculations_on_pol_num            (policy_number)
#  index_policy_calculations_on_representative_id  (representative_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (representative_id => representatives.id)
#

class PolicyCalculation < ActiveRecord::Base
  has_many :manual_class_calculations, dependent: :destroy
  has_many :claim_calculations, dependent: :destroy
  has_many :policy_coverage_status_histories, dependent: :destroy
  has_many :policy_program_histories, dependent: :destroy
  has_many :payroll_calculations, through: :manual_class_calculations
  belongs_to :representative
  belongs_to :account

  delegate :name, to: :account, prefix: true, allow_nil: false
  delegate :status, to: :account, prefix: true, allow_nil: false

  scope :by_representative, -> (rep_number) { where(representative_number: rep_number) }
  scope :updated_in_quarterly_report, -> { where('policy_calculations.updated_at >= ?', Date.parse('2020-07-30')) }
  scope :not_recently_updated_payroll, -> { joins(manual_class_calculations: :payroll_calculations).where(payroll_calculations: { recently_updated: false }).distinct }
  scope :current_coverage_statuses, -> { all.select(:current_coverage_status).map(&:current_coverage_status).reject(&:blank?).uniq }
  scope :bwc, -> { where(data_source: 'bwc') }

  before_destroy :delete_claims

  def representative_name
    self.representative&.abbreviated_name
  end

  # Add Papertrail as history tracking
  has_paper_trail :on => [:update]

  def self.find_by_rep_and_policy(rep_number, policy_number)
    find_by(representative_number: rep_number, policy_number: policy_number)
  end

  # def claim_calculations
  #   ClaimCalculation.by_representative(self.representative_number).where(policy_number: self.policy_number)
  # end

  # def manual_class_calculations
  #   ManualClassCalculation.by_representative(self.representative_number).where(policy_number: self.policy_number)
  # end

  def self.update_or_create(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj.save
    obj
  end

  def self.assign_or_new(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj
  end

  def self.search(search)
    where("policy_number LIKE ?", "%#{search}%")
  end

  def self.to_csv
    attributes = self.column_names

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |policy|
        csv << attributes.map { |attr| policy.send(attr) }
      end
    end
  end

  def public_employer?
    self.employer_type == 'PEC'
  end

  def calculate_experience
    self.manual_class_calculations.find_each(&:calculate_payroll)

    @policy_total_four_year_payroll = self.manual_class_calculations.sum(:manual_class_four_year_period_payroll).round(0)
    @policy_total_expected_losses   = self.manual_class_calculations.map(&:expected_losses_without_estimates).compact.sum.round(0) # NEED NO ESTIMATED PAYROLL IN THIS CALCULATION
    @policy_total_current_payroll   = self.manual_class_calculations.sum(:manual_class_current_estimated_payroll).round(0)

    if @policy_total_expected_losses <= 2000
      @credibility_row                     = BwcCodesCredibilityMaxLoss.where("expected_losses >= :expected_losses", expected_losses: @policy_total_expected_losses).min
      @credibility_row.credibility_group   = 0
      @credibility_row.expected_losses     = 0
      @credibility_row.credibility_percent = 0
      @credibility_row.group_maximum_value = 250000
    elsif @policy_total_expected_losses >= 1000000
      @credibility_row = BwcCodesCredibilityMaxLoss.find_by(expected_losses: 1000000)
    else
      @credibility_row = BwcCodesCredibilityMaxLoss.where("expected_losses >= :expected_losses", expected_losses: @policy_total_expected_losses).min
      @credibility_row = BwcCodesCredibilityMaxLoss.find_by(credibility_group: (@credibility_row.credibility_group - 1))
    end

    self.manual_class_calculations.find_each { |manual_class| manual_class.calculate_limited_losses(@credibility_row.credibility_group) }

    @policy_total_limited_losses = self.manual_class_calculations.map { |manual| manual.limited_losses_without_estimates(@credibility_row.credibility_group) }.compact.sum.round(0) # NEED NO ESTIMATED PAYROLL IN THIS CALCULATION

    self.claim_calculations.each { |claim| claim.recalculate_experience(@credibility_row.group_maximum_value) }

    @group_rating = GroupRating.find_by(process_representative: self.representative_number)

    start_date = @group_rating.experience_period_lower_date
    end_date   = @group_rating.experience_period_upper_date

    if public_employer?
      start_date = start_date.beginning_of_year
      end_date   = start_date.end_of_year
    end

    @claims = self.claim_calculations.where("claim_injury_date >= :experience_period_lower_date and claim_injury_date <= :experience_period_upper_date",
                                            experience_period_lower_date: start_date,
                                            experience_period_upper_date: end_date)

    if @claims.any?
      @policy_total_modified_losses_group_reduced      = @claims.sum(:claim_modified_losses_group_reduced).round(2)
      @policy_total_modified_losses_individual_reduced = @claims.sum(:claim_modified_losses_individual_reduced).round(2)
      @policy_total_claims_count                       = @claims.count
      @policy_group_ratio                              = @policy_total_expected_losses == 0.0 ? 0 : (@policy_total_modified_losses_group_reduced / @policy_total_expected_losses).round(4)
    else
      @policy_total_modified_losses_group_reduced      = 0
      @policy_total_modified_losses_individual_reduced = 0
      @policy_group_ratio                              = 0
      @policy_total_claims_count                       = 0
    end

    @policy_individual_total_modifier                    = @policy_total_limited_losses == 0 ? 0 : (((@policy_total_modified_losses_individual_reduced - @policy_total_limited_losses) / @policy_total_limited_losses) * @credibility_row.credibility_percent).round(2)
    @policy_individual_experience_modified_rate          = (@policy_individual_total_modifier + 1).round(2)
    @policy_individual_adjusted_experience_modified_rate = adjusted_total_modifier(@policy_individual_total_modifier).round(2)

    self.update_attributes(
      policy_total_modified_losses_group_reduced:          @policy_total_modified_losses_group_reduced,
      policy_total_modified_losses_individual_reduced:     @policy_total_modified_losses_individual_reduced,
      policy_total_claims_count:                           @policy_total_claims_count,
      policy_individual_total_modifier:                    @policy_individual_total_modifier,
      policy_individual_experience_modified_rate:          @policy_individual_experience_modified_rate,
      policy_individual_adjusted_experience_modified_rate: @policy_individual_adjusted_experience_modified_rate,
      policy_group_ratio:                                  @policy_group_ratio,
      policy_total_expected_losses:                        @policy_total_expected_losses,
      policy_total_four_year_payroll:                      @policy_total_four_year_payroll,
      policy_total_current_payroll:                        @policy_total_current_payroll,
      policy_credibility_percent:                          @credibility_row.credibility_percent,
      policy_credibility_group:                            @credibility_row.credibility_group,
      policy_total_limited_losses:                         @policy_total_limited_losses,
      policy_maximum_claim_value:                          @credibility_row.group_maximum_value
    )
  end

  def calculate_premium
    @administrative_rate = (1 + BwcCodesConstantValue.find_by(name: 'administrative_rate', completed_date: nil).rate)

    # TODO: Potentially ADD DWRF Rate Here

    self.manual_class_calculations.find_each { |manual_class_calculation| manual_class_calculation.calculate_premium(self.policy_individual_adjusted_experience_modified_rate + 1, @administrative_rate) }

    @policy_total_standard_premium      = self.manual_class_calculations.sum(:manual_class_standard_premium).round(0)
    @policy_total_individual_premium    = self.manual_class_calculations.sum(:manual_class_estimated_individual_premium).round(2)
    @policy_adjusted_standard_premium   = adjust_premium_size_factors(@policy_total_standard_premium)&.round(0)
    @policy_adjusted_individual_premium = calculate_premium_with_assessments(@policy_total_individual_premium, @policy_total_standard_premium)
    @collection                         = self.manual_class_calculations.pluck(:manual_class_industry_group).uniq
    @highest_industry_group             = { industry_group: @collection.first, standard_premium: industry_group_sum(@collection.first) }

    @collection.each do |item|
      industry_group_item_sum = industry_group_sum(item)
      @highest_industry_group = { industry_group: item, standard_premium: industry_group_item_sum } if industry_group_item_sum > @highest_industry_group[:standard_premium]
    end

    # Added this logic to default to industry_group 7 when a policy is calculated to industry_group 9 and then changed to 8 if there is more premium in 8 than 7
    if @highest_industry_group == 9
      industry_group_seven_sum = industry_group_sum(7)
      industry_group_eight_sum = industry_group_sum(8)

      @highest_industry_group  = { industry_group: 7, standard_premium: industry_group_seven_sum } if 7.in? @collection
      @highest_industry_group  = { industry_group: 8, standard_premium: industry_group_eight_sum } if industry_group_eight_sum > industry_group_seven_sum && 8.in?(@collection)
    end

    # ADDED NEW LOGIC FOR CURRENT PAYROLL FIX FOR NEW POLICIES
    current_payroll_fix unless self.policy_creation_date.nil?

    @policy_total_individual_premium = 120.00 if @policy_total_individual_premium < 120

    self.update_attributes(policy_industry_group:              @highest_industry_group[:industry_group],
                           policy_total_individual_premium:    @policy_total_individual_premium,
                           policy_total_standard_premium:      @policy_total_standard_premium,
                           policy_adjusted_standard_premium:   @policy_adjusted_standard_premium,
                           policy_adjusted_individual_premium: @policy_adjusted_individual_premium)

    self.manual_class_calculations.each do |manual|
      next unless self.policy_total_individual_premium.present?
      manual.calculate_premium(self.policy_individual_adjusted_experience_modified_rate + 1, @administrative_rate) if manual.manual_class_estimated_individual_premium.nil? # recalculate premium just in case
      manual.update_attributes(manual_class_industry_group_premium_percentage: (manual.manual_class_estimated_individual_premium / @policy_total_individual_premium).round(4))
    end
  end

  def calculate_premium_with_assessments(policy_total_individual_premium = self.policy_total_individual_premium, policy_total_standard_premium = self.policy_total_standard_premium)
    assessments = total_assessments(policy_total_individual_premium, policy_total_standard_premium)
    adjust_premium_size_factors(policy_total_standard_premium)&.round(0) + assessments
  end

  def total_assessments(policy_total_individual_premium = self.policy_total_individual_premium, policy_total_standard_premium = self.policy_total_standard_premium)
    policy_total_individual_premium - policy_total_standard_premium
  end

  def max_assessment
    (self.policy_adjusted_standard_premium || 0) * 0.15
  end

  def calculate_premium_for_risk(new_mod_rate)
    administrative_rate = BwcCodesConstantValue.find_by(name: 'administrative_rate', completed_date: nil).rate

    total_individual_premium = self.manual_class_calculations.map do |manual|
      manual.calculate_potential_premium(new_mod_rate, administrative_rate)
    end.sum

    total_standard_premium = self.manual_class_calculations.map do |manual|
      manual.calculate_potential_standard_premium(new_mod_rate)
    end.sum

    calculate_premium_with_assessments(total_individual_premium, total_standard_premium)
  end

  def adjust_premium_size_factors(total_standard_premium)
    return 0 if total_standard_premium < 0
    return total_standard_premium if public_employer?

    if total_standard_premium > 500000
      405750 + ((total_standard_premium - 500000) * 0.75).round(0)
    elsif total_standard_premium > 100000
      85750 + ((total_standard_premium - 100000) * 0.8).round(0)
    elsif total_standard_premium > 5000
      # 5000 + ((Y10 - 5000) * 0.85).round(0) Y10?
      5000 + ((total_standard_premium - 5000) * 0.85).round(0)
    else
      total_standard_premium
    end
  end

  def adjusted_total_modifier(policy_individual_total_modifier = self.policy_individual_total_modifier)
    experience_modifier = (policy_individual_total_modifier || 0) + 1

    if public_employer? # Added per client request 1/20/21
      if experience_modifier > 1.75
        experience_modifier = (experience_modifier * 1.05).round(2)
      end

      if experience_modifier < 0.76
        experience_modifier = (experience_modifier * 0.95).round(2)
      end
    else
      if experience_modifier > 2.00
        experience_modifier = (experience_modifier * 1.05).round(2)
      end

      if experience_modifier < 0.91
        experience_modifier = (experience_modifier * 0.95).round(2)
      end
    end

    experience_modifier - 1
  end

  def delete_claims
    self.claim_calculations.destroy_all
  end

  private

  def industry_group_sum(industry_group)
    self.manual_class_calculations.where(manual_class_industry_group: industry_group).sum(:manual_class_standard_premium)
  end

  def current_payroll_fix
    group_rating_calc = GroupRating.find_by(process_representative: self.representative_number)
    start_date        = group_rating_calc.current_payroll_period_lower_date + 1.year
    end_date          = group_rating_calc.current_payroll_period_upper_date + 1.year

    if public_employer?
      start_date = start_date.beginning_of_year
      end_date   = start_date.end_of_year
    end

    return unless self.policy_creation_date < start_date

    new_policy_individual_premium = 0

    self.manual_class_calculations.each do |manual|
      manual_class_current_payroll              = manual.payroll_calculations.where("reporting_period_start_date >= :current_payroll_period_lower_date and reporting_period_start_date < :current_payroll_period_upper_date",
                                                                                    current_payroll_period_lower_date: start_date,
                                                                                    current_payroll_period_upper_date: end_date).sum(:manual_class_payroll).round(2)
      manual_class_standard_premium             = ((manual.manual_class_base_rate * manual_class_current_payroll * self.policy_individual_experience_modified_rate) / 100).round(2)
      manual_class_modification_rate            = (manual.manual_class_base_rate * self.policy_individual_experience_modified_rate).round(2)
      manual_class_individual_total_rate        = ((manual_class_modification_rate * @administrative_rate)).round(4) / 100
      manual_class_estimated_individual_premium = (manual_class_current_payroll * manual_class_individual_total_rate).round(2)

      new_policy_individual_premium += manual_class_estimated_individual_premium
    end

    if new_policy_individual_premium > @policy_total_individual_premium
      self.manual_class_calculations.find_each do |manual_class|
        manual_class.calculate_payroll(true)
        manual_class.calculate_premium(self.policy_individual_adjusted_experience_modified_rate + 1, @administrative_rate)
      end
      # Added logic to update current payroll on 7/24/07
      @policy_total_current_payroll       = self.manual_class_calculations.sum(:manual_class_current_estimated_payroll).round(0)
      @policy_total_standard_premium      = self.manual_class_calculations.sum(:manual_class_standard_premium).round(0)
      @policy_adjusted_standard_premium   = adjust_premium_size_factors(@policy_total_standard_premium)&.round(0)
      @policy_total_individual_premium    = self.manual_class_calculations.sum(:manual_class_estimated_individual_premium).round(2)
      @policy_adjusted_individual_premium = calculate_premium_with_assessments(@policy_total_individual_premium, @policy_total_standard_premium)

      self.update_attributes(policy_total_current_payroll: @policy_total_current_payroll, policy_total_standard_premium: @policy_total_standard_premium)
    end
  end
end
