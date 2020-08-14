# == Schema Information
#
# Table name: claim_calculations
#
#  id                                        :integer          not null, primary key
#  claim_activity_status                     :string
#  claim_activity_status_effective_date      :date
#  claim_combined                            :string
#  claim_group_multiplier                    :float
#  claim_group_reduced_amount                :float
#  claim_handicap_percent                    :float
#  claim_handicap_percent_effective_date     :date
#  claim_individual_multiplier               :float
#  claim_individual_reduced_amount           :float
#  claim_injury_date                         :date
#  claim_manual_number                       :integer
#  claim_medical_paid                        :float
#  claim_mira_indemnity_reserve_amount       :float
#  claim_mira_medical_reserve_amount         :float
#  claim_mira_ncci_injury_type               :string
#  claim_mira_non_reducible_indemnity_paid   :float
#  claim_mira_non_reducible_indemnity_paid_2 :float
#  claim_mira_reducible_indemnity_paid       :float
#  claim_modified_losses_group_reduced       :float
#  claim_modified_losses_individual_reduced  :float
#  claim_number                              :string
#  claim_rating_plan_indicator               :string
#  claim_status                              :string
#  claim_status_effective_date               :date
#  claim_subrogation_percent                 :float
#  claim_total_subrogation_collected         :float
#  claim_type                                :string
#  claim_unlimited_limited_loss              :float
#  claimant_date_of_birth                    :date
#  claimant_date_of_death                    :date
#  claimant_name                             :string
#  combined_into_claim_number                :string
#  data_source                               :string
#  indemnity_settlement_date                 :date
#  maximum_medical_improvement_date          :date
#  medical_settlement_date                   :date
#  policy_individual_maximum_claim_value     :float
#  policy_number                             :integer
#  policy_type                               :string
#  representative_number                     :integer
#  settled_claim                             :string
#  settlement_type                           :string
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#  policy_calculation_id                     :integer
#
# Indexes
#
#  index_claim_calc_on_pol_num_and_claim_num          (policy_number,claim_number)
#  index_claim_calculations_on_policy_calculation_id  (policy_calculation_id)
#
# Foreign Keys
#
#  fk_rails_...  (policy_calculation_id => policy_calculations.id)
#

class ClaimCalculation < ActiveRecord::Base
  belongs_to :policy_calculation

  attr_accessor :comp_awarded, :medical_paid, :mira_reserve, :address_id
  scope :by_representative, -> (rep_number) { where(representative_number: rep_number) }

  def self.update_or_create(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj.save
    obj
  end

  def self.to_csv
    require 'csv'

    CSV.generate do |csv|
      csv << csv_column_headers

      all.each do |record|
        csv << csv_formatted_attributes(record)
      end
    end
  end

  def representative_name
    Representative.find_by_representative_number(representative_number)&.abbreviated_name
  end

  def policy_name
    self.policy_calculation&.account_name
  end

  def clicd_detail_records
    ClicdDetailRecord.where('clicd_detail_records.claim_number IN (?)', [claim_number, claim_number&.strip, "#{claim_number} "]).where(representative_number: representative_number, policy_number: policy_number)
  end

  def weekly_mira_detail_record
    WeeklyMiraDetailRecord.where('weekly_mira_detail_records.claim_number IN (?)', [claim_number, claim_number&.strip, "#{claim_number} "]).where(representative_number: representative_number, policy_number: policy_number).order(updated_at: :desc)&.first
  end

  def mira_detail_record
    weekly_mira_detail_record || MiraDetailRecord.where('mira_detail_records.claim_number IN (?)', [claim_number, claim_number&.strip, "#{claim_number} "]).where(representative_number: representative_number, policy_number: policy_number).order(updated_at: :desc)&.first
  end

  def democ_detail_records
    DemocDetailRecord.filter_by(representative_number).where('democ_detail_records.claim_number IN (?)', ["#{self.claim_number} ", self.claim_number, self.claim_number.strip]).where(policy_number: self.policy_number)
  end

  def democ_detail_record
    return @democ_detail_record if @democ_detail_record.present?

    @democ_detail_record = democ_detail_records.last
  end

  def claim_notes
    ClaimNote.where(representative_number: self.representative_number, policy_number: self.policy_number).where('claim_number IN (?)', [self.claim_number, self.claim_number.strip, "#{self.claim_number} "])
  end

  def address
    ClaimAddress.find_by(claim_number: claim_number, representative_number: representative_number, policy_number: policy_number)
  end

  def program_type
    @claim_calculation&.policy_calculation&.account&.account_programs&.first&.program_type
  end

  def comp_awarded
    return 0 unless claim_handicap_percent.present? && claim_subrogation_percent.present?
    (((claim_mira_reducible_indemnity_paid + claim_mira_non_reducible_indemnity_paid) * (1 - claim_subrogation_percent) - (claim_mira_non_reducible_indemnity_paid)) * (1 - claim_handicap_percent) + (claim_mira_non_reducible_indemnity_paid)) * claim_group_multiplier
  end

  def medical_paid
    return 0 unless claim_medical_paid.present? && claim_subrogation_percent.present?
    (((claim_medical_paid + claim_mira_non_reducible_indemnity_paid_2) * (1 - claim_subrogation_percent) - claim_mira_non_reducible_indemnity_paid_2) * (1 - claim_handicap_percent) + claim_mira_non_reducible_indemnity_paid_2) * claim_group_multiplier
  end

  def mira_reserve
    return 0 unless claim_handicap_percent.present? && claim_subrogation_percent.present?
    ((1 - claim_handicap_percent) * (claim_mira_medical_reserve_amount + (claim_mira_indemnity_reserve_amount)) * claim_group_multiplier * (1 - claim_subrogation_percent))
  end

  def ecp_enabled?
    democ_detail_record&.enhanced_care_program_indicator == 'Y'
  end

  def representative_name_and_abbreviation
    representative = Representative.find_by(representative_number: self.representative_number)

    "#{representative.company_name} (#{representative.abbreviated_name})"
  end

  def recalculate_experience(group_maximum_value)

    #WHEN I COME IN TO FIX CLAIMS FOR STEVE, ADD SI TOTAL ON CLAIM CALCUALTIONS MODEL THEN FIX IN REPORT
    #### 3/14/2017 ####

    @policy_calculation = self.policy_calculation

    @claim_group_multiplier =
      if self.claim_unlimited_limited_loss.nil? || self.claim_unlimited_limited_loss < 250000
        1
      else
        (250000 / self.claim_unlimited_limited_loss)
      end

    @claim_individual_multiplier =
      if (group_maximum_value.nil? || self.claim_unlimited_limited_loss.nil? || group_maximum_value > self.claim_unlimited_limited_loss || group_maximum_value == 0 || self.claim_unlimited_limited_loss == 0)
        1
      else
        group_maximum_value / self.claim_unlimited_limited_loss
      end

    @claim_group_reduced_amount =
      (((self.claim_mira_non_reducible_indemnity_paid + self.claim_mira_non_reducible_indemnity_paid_2) * @claim_group_multiplier) + ((self.claim_medical_paid + self.claim_mira_medical_reserve_amount + self.claim_mira_reducible_indemnity_paid + self.claim_mira_indemnity_reserve_amount) * @claim_group_multiplier * (1 - self.claim_handicap_percent)))

    @claim_individual_reduced_amount =
      (((self.claim_mira_non_reducible_indemnity_paid +
        self.claim_mira_non_reducible_indemnity_paid_2) * @claim_individual_multiplier) +
        (
        (self.claim_medical_paid +
          self.claim_mira_medical_reserve_amount +
          self.claim_mira_reducible_indemnity_paid +
          self.claim_mira_indemnity_reserve_amount) * @claim_individual_multiplier * (1 - self.claim_handicap_percent)))

    @claim_subrogation_percent =
      if self.claim_total_subrogation_collected == 0.0
        0
      elsif self.claim_total_subrogation_collected > self.claim_unlimited_limited_loss
        1
      else
        self.claim_total_subrogation_collected / self.claim_unlimited_limited_loss
      end

    @claim_modified_losses_group_reduced = @claim_group_reduced_amount * (1 - @claim_subrogation_percent)

    @claim_modified_losses_individual_reduced = (@claim_individual_reduced_amount * (1 - @claim_subrogation_percent))

    # ECP Addition - 7/28/2020
    @claim_modified_losses_group_reduced      = ecp_enabled? ? (@claim_modified_losses_group_reduced / 2) : @claim_modified_losses_group_reduced
    @claim_modified_losses_individual_reduced = ecp_enabled? ? (@claim_modified_losses_individual_reduced / 2) : @claim_modified_losses_individual_reduced

    update_attributes(policy_individual_maximum_claim_value: group_maximum_value, claim_individual_multiplier: @claim_individual_multiplier, claim_group_reduced_amount: @claim_group_reduced_amount, claim_individual_reduced_amount: @claim_individual_reduced_amount, claim_modified_losses_individual_reduced: @claim_modified_losses_individual_reduced, claim_group_multiplier: @claim_group_multiplier, claim_subrogation_percent: @claim_subrogation_percent, claim_modified_losses_group_reduced: @claim_modified_losses_group_reduced)
  end

  def medical_last_paid_date
    return unless @democ_detail_record.present?
    @democ_detail_record.& last_paid_medical_date
  end

  def indemnity_last_paid_date
    return unless @democ_detail_record.present?
    @democ_detail_record.& last_paid_indemnity_date
  end

  def non_at_fault
    return unless @democ_detail_record.present?
    @democ_detail_record.& non_at_fault
  end

  def total_loss_of_claim
    self.policy_calculation.manual_class_calculations.sum(:manual_class_expected_losses).round(0)
  end

  def max_value
    self.policy_calculation.policy_maximum_claim_value&.round(0)
  end

  private

  def self.csv_column_headers
    %w[id claim_combined claim_manual_number claim_number claim_status claim_type claimant_name combined_into_claim_number data_source policy_number policy_type updated_at]
  end

  def self.csv_formatted_attributes(record)
    [
      record.id,
      record.claim_combined,
      record.claim_manual_number,
      record.claim_number,
      record.claim_status,
      record.claim_type,
      record.claimant_name,
      record.combined_into_claim_number,
      record.data_source,
      record.policy_number,
      record.policy_type,
      I18n.l(record.updated_at)
    ]
  end
end
