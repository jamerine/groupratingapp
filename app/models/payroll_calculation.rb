# == Schema Information
#
# Table name: payroll_calculations
#
#  id                                                            :integer          not null, primary key
#  data_source                                                   :string
#  manual_class_payroll                                          :float
#  manual_class_rate                                             :float
#  manual_class_transferred                                      :integer
#  manual_class_type                                             :string
#  manual_number                                                 :integer
#  number_of_employees                                           :integer
#  payroll_origin                                                :string
#  policy_number                                                 :integer
#  policy_transferred                                            :integer
#  policy_type                                                   :string
#  recently_updated                                              :boolean          default(FALSE)
#  reporting_period_end_date                                     :date
#  reporting_period_start_date                                   :date
#  reporting_type                                                :string
#  representative_number                                         :integer
#  transfer_creation_date                                        :date
#  created_at                                                    :datetime         not null
#  updated_at                                                    :datetime         not null
#  manual_class_calculation_id                                   :integer
#  process_payroll_all_transactions_breakdown_by_manual_class_id :integer
#
# Indexes
#
#  index_payroll_calc_on_pol_num_and_man_num                  (policy_number,manual_number)
#  index_payroll_calculations_on_manual_class_calculation_id  (manual_class_calculation_id)
#
# Foreign Keys
#
#  fk_rails_...  (manual_class_calculation_id => manual_class_calculations.id)
#

class PayrollCalculation < ActiveRecord::Base

  belongs_to :manual_class_calculation
  has_one :policy_calculation, foreign_key: :policy_number, primary_key: :policy_number

  TRANSFER_PAYROLL_ORIGINS = %w[partial_transfer full_transfer man_reclass_full_transfer man_reclass_partial_transfer]

  validates :reporting_period_start_date, :presence => true
  validates :reporting_period_end_date, :presence => true
  validates :manual_class_payroll, :presence => true
  validates :payroll_origin, :presence => true
  validates :data_source, :presence => true

  scope :with_estimated_payroll, -> (with_estimated_payroll) { with_estimated_payroll ? where('1 = 1') : where.not(reporting_type: 'E') }
  scope :recently_updated, -> { where(recently_updated: true) }
  scope :not_recently_updated, -> { where(recently_updated: false) }
  scope :by_representative, -> (rep_number) { where(representative_number: rep_number) }
  scope :within_two_years, -> { where('payroll_calculations.updated_at >= ?', 2.years.ago) }
  scope :with_policy_updated_in_quarterly_report, -> { joins(:policy_calculation).where('policy_calculations.updated_at >= ?', Date.parse('2020-07-30')).distinct }
  scope :bwc, -> { where(data_source: 'bwc') }

  # after_create :calculate
  # after_destroy :calculate

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

  # def self.assign_or_new(attributes)
  #   obj = first || new
  #   obj.assign_attributes(attributes)
  #   obj
  # end

  private

  def calculate
    self.manual_class_calculation.policy_calculation.calculate_experience
    self.manual_class_calculation.policy_calculation.calculate_premium
    self.manual_class_calculation.policy_calculation.account.group_rating
  end

  def self.csv_column_headers
    %w[id policy_number manual_class_type manual_number reporting_period_start_date reporting_period_end_date manual_class_payroll reporting_type policy_transferred transfer_creation_date data_source manual_class_rate manual_class_transferred updated_at]
  end

  def self.csv_formatted_attributes(record)
    [
      record.id,
      record.policy_number,
      record.manual_class_type,
      record.manual_number,
      record.reporting_period_start_date,
      record.reporting_period_end_date,
      record.manual_class_payroll,
      record.reporting_type,
      record.policy_transferred,
      record.transfer_creation_date,
      record.data_source,
      record.manual_class_rate,
      record.manual_class_transferred,
      I18n.l(record.updated_at)
    ]
  end

end
