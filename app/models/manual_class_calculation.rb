class ManualClassCalculation < ActiveRecord::Base

  belongs_to :policy_calculation
  has_many :payroll_calculations, dependent: :destroy

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
        csv << attributes.map{ |attr| manual_class.send(attr) }
      end
    end
  end

  def calculate_payroll
    self.transaction do
      @group_rating = GroupRating.find_by(process_representative: self.representative_number)

      @policy_creation = self.policy_calculation.policy_coverage_status_histories.find_by(coverage_status: 'ACTIV')

      if @policy_creation.nil?
        @policy_creation_date = self.policy_calculation.policy_coverage_status_histories.first.coverage_effective_date
      else
        @policy_creation_date = @policy_creation.coverage_effective_date
      end

      @self_four_year_payroll_lower_date = @policy_creation_date > @group_rating.experience_period_lower_date ? @policy_creation_date : @group_rating.experience_period_lower_date

      @manual_class_self_four_year_sum = self.payroll_calculations.where("reporting_period_start_date BETWEEN :experience_period_lower_date and :experience_period_upper_date and payroll_origin = :payroll_origin", experience_period_lower_date: @self_four_year_payroll_lower_date, experience_period_upper_date: @group_rating.experience_period_upper_date, payroll_origin: 'payroll').sum(:manual_class_payroll).round(2)

      @manual_class_comb_four_year_sum = self.payroll_calculations.where("(reporting_period_start_date BETWEEN :experience_period_lower_date and :experience_period_upper_date) and payroll_origin != :payroll_origin", experience_period_lower_date: @group_rating.experience_period_lower_date, experience_period_upper_date: @group_rating.experience_period_upper_date, payroll_origin: 'payroll').sum(:manual_class_payroll).round(2)

      @manual_class_four_year_sum = @manual_class_self_four_year_sum + @manual_class_comb_four_year_sum

      @manual_class_current_payroll = self.payroll_calculations.where("reporting_period_start_date >= :current_payroll_period_lower_date and reporting_period_start_date < :current_payroll_period_upper_date", current_payroll_period_lower_date: @group_rating.current_payroll_period_lower_date, current_payroll_period_upper_date: @group_rating.current_payroll_period_upper_date).sum(:manual_class_payroll).round(2)

      @bwc_base_rate = BwcCodesBaseRatesExpLossRate.find_by(class_code: self.manual_number)

      if @bwc_base_rate.nil?
        @manual_class_expected_losses = 0
        @manual_class_expected_loss_rate = 0
        @manual_class_base_rate = 0
      else
        @manual_class_expected_losses = ((@bwc_base_rate.expected_loss_rate * @manual_class_four_year_sum)/100).round(0)
        @manual_class_expected_loss_rate = @bwc_base_rate.expected_loss_rate
        @manual_class_base_rate = @bwc_base_rate.base_rate
      end


      self.update_attributes(manual_class_current_estimated_payroll: @manual_class_current_payroll,
      manual_class_four_year_period_payroll: @manual_class_four_year_sum,
      manual_class_expected_losses: @manual_class_expected_losses,
      manual_class_expected_loss_rate: @manual_class_expected_loss_rate,
      manual_class_base_rate: @manual_class_base_rate
      )
    end #end transaction
  end

  def calculate_limited_losses(credibility_group)
    self.transaction do

      @limited_loss_rate_row = BwcCodesLimitedLossRatio.find_by(industry_group: self.manual_class_industry_group, credibility_group: credibility_group)

      if @limited_loss_rate_row.nil?
        @limited_loss_rate = 0
        @limited_losses = 0
      else
        @limited_loss_rate = (@limited_loss_rate_row.limited_loss_ratio)
        @limited_losses = (self.manual_class_expected_losses * @limited_loss_rate).round(0)
      end

      self.update_attributes(
      manual_class_limited_losses: @limited_losses,
      manual_class_limited_loss_rate: @limited_loss_rate
      )

   end # transaction end
  end

  def calculate_premium(policy_individual_experience_modified_rate, administrative_rate)
    self.transaction do

        @manual_class_standard_premium = ((self.manual_class_base_rate * self.manual_class_current_estimated_payroll * policy_individual_experience_modified_rate)/100).round(2)
        @manual_class_modification_rate = (self.manual_class_base_rate * policy_individual_experience_modified_rate).round(2)
        @manual_class_individual_total_rate = ((@manual_class_modification_rate * administrative_rate)).round(4)/100
        @manual_class_estimated_individual_premium = (self.manual_class_current_estimated_payroll * @manual_class_individual_total_rate).round(2)

        self.update_attributes(manual_class_individual_total_rate: @manual_class_individual_total_rate,
        manual_class_standard_premium: @manual_class_standard_premium, manual_class_modification_rate: @manual_class_modification_rate, manual_class_estimated_individual_premium: @manual_class_estimated_individual_premium)

   end #transaction
  end


end
