# == Schema Information
#
# Table name: manual_class_calculations
#
#  id                                             :integer          not null, primary key
#  data_source                                    :string
#  manual_class_base_rate                         :float
#  manual_class_current_estimated_payroll         :float
#  manual_class_estimated_group_premium           :float
#  manual_class_estimated_individual_premium      :float
#  manual_class_expected_loss_rate                :float
#  manual_class_expected_losses                   :float
#  manual_class_four_year_period_payroll          :float
#  manual_class_group_total_rate                  :float
#  manual_class_individual_total_rate             :float
#  manual_class_industry_group                    :integer
#  manual_class_industry_group_premium_percentage :float
#  manual_class_industry_group_premium_total      :float
#  manual_class_limited_loss_rate                 :float
#  manual_class_limited_losses                    :float
#  manual_class_modification_rate                 :float
#  manual_class_standard_premium                  :float
#  manual_class_type                              :string
#  manual_number                                  :integer
#  policy_number                                  :integer
#  representative_number                          :integer
#  created_at                                     :datetime         not null
#  updated_at                                     :datetime         not null
#  policy_calculation_id                          :integer
#
# Indexes
#
#  index_man_class_calc_pol_num_and_man_num                  (policy_number,manual_number)
#  index_manual_class_calculations_on_policy_calculation_id  (policy_calculation_id)
#
# Foreign Keys
#
#  fk_rails_...  (policy_calculation_id => policy_calculations.id)
#

class ManualClassCalculation < ActiveRecord::Base
  belongs_to :policy_calculation
  has_many :payroll_calculations, dependent: :destroy
  has_one :account, through: :policy_calculation
  has_one :representative, through: :account

  scope :by_representative, -> (rep_number) { where(representative_number: rep_number) }
  scope :bwc, -> { where(data_source: 'bwc') }

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

  def self.to_csv
    attributes = self.column_names

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |manual_class|
        csv << attributes.map { |attr| manual_class.send(attr) }
      end
    end
  end

  # def payroll_calculations
  #   PayrollCalculation.by_representative(self.representative_number).where(policy_number: self.policy_number, manual_number: self.manual_number)
  # end

  def calculate_payroll(plus_one_year = nil)
    @group_rating = GroupRating.find_by(process_representative: self.representative_number)
    @group_rating.assign_attributes(current_payroll_period_lower_date: (@group_rating.current_payroll_period_lower_date + 1.year), current_payroll_period_upper_date: (@group_rating.current_payroll_period_upper_date + 1.year)) unless plus_one_year.nil?

    @policy_creation      = self.policy_calculation.policy_coverage_status_histories.order(:coverage_effective_date).where(coverage_status: 'ACTIV').first
    @policy_creation_dip  = self.policy_calculation.policy_coverage_status_histories.find_by(coverage_status: 'DIP  ')
    @policy_creation      = @policy_creation_dip if @policy_creation_dip && @policy_creation && @policy_creation_dip.coverage_effective_date < @policy_creation.coverage_effective_date
    @policy_creation_date = @policy_creation.nil? ? self.policy_calculation.policy_coverage_status_histories.order(:coverage_effective_date).first.coverage_effective_date : @policy_creation.coverage_effective_date
    start_date            = @group_rating.experience_period_lower_date
    end_date              = @group_rating.experience_period_upper_date
    payroll_start_date    = @group_rating.current_payroll_period_lower_date
    payroll_end_date      = @group_rating.current_payroll_period_upper_date

    if self.policy_calculation.public_employer?
      start_date         = (start_date + 1.year).beginning_of_year
      end_date           = end_date.end_of_year
      payroll_start_date = (payroll_start_date + 1.year).beginning_of_year
      payroll_end_date   = payroll_start_date.end_of_year
    end

    four_year_payroll_lower_date = @policy_creation_date > start_date ? @policy_creation_date : start_date

    # CHANGE as of 06/20/2017 changed the four year sum calculations
    @manual_class_self_four_year_sum = self.payroll_calculations.where("payroll_calculations.reporting_period_start_date BETWEEN :experience_period_lower_date AND :experience_period_upper_date AND (payroll_calculations.payroll_origin NOT IN (:origins))",
                                                                       experience_period_lower_date: four_year_payroll_lower_date,
                                                                       experience_period_upper_date: end_date,
                                                                       origins:                      PayrollCalculation::TRANSFER_PAYROLL_ORIGINS).sum(:manual_class_payroll).round(2)
    @manual_class_comb_four_year_sum = self.payroll_calculations.where("(payroll_calculations.reporting_period_start_date BETWEEN :experience_period_lower_date and :experience_period_upper_date) AND (payroll_calculations.payroll_origin IN (:origins))",
                                                                       experience_period_lower_date: four_year_payroll_lower_date,
                                                                       experience_period_upper_date: end_date,
                                                                       origins:                      PayrollCalculation::TRANSFER_PAYROLL_ORIGINS).sum(:manual_class_payroll).round(2)
    @manual_class_four_year_sum      = @manual_class_self_four_year_sum + @manual_class_comb_four_year_sum
    @manual_class_four_year_sum      = @manual_class_four_year_sum < 0 ? 0 : @manual_class_four_year_sum
    current_payroll_records          = self.payroll_calculations.where("payroll_calculations.reporting_period_start_date >= :current_payroll_period_lower_date and payroll_calculations.reporting_period_start_date < :current_payroll_period_upper_date",
                                                                       current_payroll_period_lower_date: payroll_start_date,
                                                                       current_payroll_period_upper_date: payroll_end_date)
    current_payroll_records          = current_payroll_records.where("((payroll_calculations.reporting_type = 'E' AND payroll_calculations.payroll_origin NOT IN (:origins)) OR payroll_calculations.reporting_type != 'E')",
                                                                     origins: PayrollCalculation::TRANSFER_PAYROLL_ORIGINS) if plus_one_year && @policy_creation_date >= 1.year.ago # Don't use E payroll for really new policies - Doug - 11/2/2020
    @manual_class_current_payroll    = current_payroll_records.sum(:manual_class_payroll).round(2)

    # Added Prorated payroll for entire year ( ie. extrapolated out for entire year projection [Multiplied out by the inverse of how long the period was for a year.] )
    if self.policy_calculation.policy_creation_date.present? && self.policy_calculation.policy_creation_date >= payroll_start_date && plus_one_year.nil?
      current_payroll = self.payroll_calculations.where("payroll_calculations.reporting_period_start_date >= :current_payroll_period_lower_date and payroll_calculations.reporting_period_start_date < :current_payroll_period_upper_date",
                                                        current_payroll_period_lower_date: payroll_start_date,
                                                        current_payroll_period_upper_date: payroll_end_date).order(reporting_period_start_date: :asc).first

      if current_payroll.nil?
        @manual_class_current_payroll = 0
      elsif current_payroll.reporting_period_start_date > payroll_start_date
        diff_ratio = 1 / ((payroll_end_date - self.policy_calculation.policy_creation_date) / (payroll_end_date - payroll_start_date))

        @manual_class_current_payroll = @manual_class_current_payroll * diff_ratio
      end
    end

    @manual_class_current_payroll = @manual_class_current_payroll < 0 ? 0 : @manual_class_current_payroll

    @bwc_base_rate = BwcCodesBaseRatesExpLossRate.find_by(class_code: self.manual_number)

    if @bwc_base_rate.nil?
      @manual_class_expected_losses    = 0
      @manual_class_expected_loss_rate = 0
      @manual_class_base_rate          = 0
    else
      expected_loss_rate               = @bwc_base_rate.expected_loss_rate || 0
      @manual_class_expected_losses    = ((expected_loss_rate * @manual_class_four_year_sum) / 100).round(0)
      @manual_class_expected_loss_rate = expected_loss_rate
      @manual_class_base_rate          = @bwc_base_rate.base_rate || 0
    end

    self.update_attributes(manual_class_current_estimated_payroll: @manual_class_current_payroll,
                           manual_class_four_year_period_payroll:  @manual_class_four_year_sum,
                           manual_class_expected_losses:           @manual_class_expected_losses,
                           manual_class_expected_loss_rate:        @manual_class_expected_loss_rate,
                           manual_class_base_rate:                 @manual_class_base_rate
    )
  end

  def expected_losses_without_estimates
    bwc_base_rate = BwcCodesBaseRatesExpLossRate.find_by(class_code: self.manual_number)
    return 0 unless bwc_base_rate.present?

    expected_loss_rate   = bwc_base_rate.expected_loss_rate || 0
    group_rating         = GroupRating.find_by(process_representative: self.representative_number)
    policy_creation      = self.policy_calculation.policy_coverage_status_histories.order(:coverage_effective_date).where(coverage_status: 'ACTIV').first
    policy_creation_dip  = self.policy_calculation.policy_coverage_status_histories.find_by(coverage_status: 'DIP  ')
    policy_creation      = policy_creation_dip if policy_creation_dip && policy_creation && policy_creation_dip.coverage_effective_date < policy_creation.coverage_effective_date
    policy_creation_date = policy_creation.nil? ? self.policy_calculation.policy_coverage_status_histories.order(:coverage_effective_date).first.coverage_effective_date : policy_creation.coverage_effective_date
    start_date           = group_rating.experience_period_lower_date
    end_date             = group_rating.experience_period_upper_date

    if self.policy_calculation.public_employer?
      start_date = (start_date + 1.year).beginning_of_year
      end_date   = end_date.end_of_year
    end

    self_four_year_payroll_lower_date = policy_creation_date > start_date ? policy_creation_date : start_date
    manual_class_self_four_year_sum   = self.payroll_calculations.with_estimated_payroll(false).where("payroll_calculations.reporting_period_start_date BETWEEN :experience_period_lower_date and :experience_period_upper_date and (payroll_calculations.payroll_origin NOT IN (:origins))",
                                                                                                      experience_period_lower_date: self_four_year_payroll_lower_date,
                                                                                                      experience_period_upper_date: end_date,
                                                                                                      origins:                      PayrollCalculation::TRANSFER_PAYROLL_ORIGINS).sum(:manual_class_payroll).round(2)
    manual_class_comb_four_year_sum   = self.payroll_calculations.with_estimated_payroll(false).where("(payroll_calculations.reporting_period_start_date BETWEEN :experience_period_lower_date and :experience_period_upper_date) and (payroll_calculations.payroll_origin IN (:origins))",
                                                                                                      experience_period_lower_date: self_four_year_payroll_lower_date,
                                                                                                      experience_period_upper_date: end_date,
                                                                                                      origins:                      PayrollCalculation::TRANSFER_PAYROLL_ORIGINS).sum(:manual_class_payroll).round(2)
    manual_class_four_year_sum        = manual_class_self_four_year_sum + manual_class_comb_four_year_sum
    manual_class_four_year_sum        = manual_class_four_year_sum < 0 ? 0 : manual_class_four_year_sum

    ((expected_loss_rate * manual_class_four_year_sum) / 100).round(0)
  end

  def calculate_limited_losses(credibility_group)
    @limited_loss_rate_row = BwcCodesLimitedLossRatio.find_by(industry_group: self.manual_class_industry_group, credibility_group: credibility_group)

    if @limited_loss_rate_row.nil?
      @limited_loss_rate = 0
      @limited_losses    = 0
    else
      @limited_loss_rate = @limited_loss_rate_row&.limited_loss_ratio || 0
      @limited_losses    = (self.manual_class_expected_losses * @limited_loss_rate).round(0)
    end

    self.update_attributes(manual_class_limited_losses: @limited_losses, manual_class_limited_loss_rate: @limited_loss_rate)
  end

  def limited_losses_without_estimates(credibility_group)
    limited_loss_rate_row = BwcCodesLimitedLossRatio.find_by(industry_group: self.manual_class_industry_group, credibility_group: credibility_group)
    return 0 unless limited_loss_rate_row.present?

    limited_loss_rate = limited_loss_rate_row.limited_loss_ratio || 0
    (expected_losses_without_estimates * limited_loss_rate).round(0)
  end

  def calculate_premium(policy_individual_experience_modified_rate, administrative_rate)
    modification_rate = (self.manual_class_base_rate * policy_individual_experience_modified_rate).round(2)
    standard_premium  = ((modification_rate * self.manual_class_current_estimated_payroll) / 100).round(2)

    individual_total_rate        = ((modification_rate * administrative_rate)).round(4) / 100
    estimated_individual_premium = (self.manual_class_current_estimated_payroll * individual_total_rate).round(2)

    self.update_attributes(manual_class_individual_total_rate:        individual_total_rate,
                           manual_class_standard_premium:             standard_premium,
                           manual_class_modification_rate:            modification_rate,
                           manual_class_estimated_individual_premium: estimated_individual_premium)
  end

  def calculate_estimated_premium(market_rate, administrative_rate)
    begin
      payroll_amount = (self.manual_class_estimated_group_premium || 0) / (self.manual_class_group_total_rate || 0)
      payroll_amount = payroll_amount.nan? ? 0.0 : payroll_amount
    rescue
      payroll_amount = 0.0
    end

    rate = (((1 + market_rate) * self.manual_class_base_rate).round(2) * (1 + administrative_rate)).round(4) / 100

    (payroll_amount * rate).round(2)
  end

  def calculate_potential_premium(new_mod_rate, administrative_rate)
    payroll_amount = (self.manual_class_estimated_individual_premium / self.manual_class_individual_total_rate)
    payroll_amount = payroll_amount.nan? ? 0.0 : payroll_amount
    rate           = (((1 + new_mod_rate) * (self.manual_class_base_rate || 0)).round(2) * (1 + administrative_rate)).round(4) / 100

    (payroll_amount * rate).round(2)
  end

  def calculate_potential_standard_premium(new_mod_rate)
    payroll_amount     = (self.manual_class_estimated_individual_premium / self.manual_class_individual_total_rate)
    payroll_amount     = payroll_amount.nan? ? 0.0 : payroll_amount
    estimated_mod_rate = ((self.manual_class_base_rate || 0) * (new_mod_rate + 1)).round(2)
    ((estimated_mod_rate * payroll_amount) / 100).round(2)
  end
end
