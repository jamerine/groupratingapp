class PolicyCalculation < ActiveRecord::Base

  has_many :manual_class_calculations, dependent: :destroy
  has_many :claim_calculations, dependent: :destroy
  has_many :policy_coverage_status_histories, dependent: :destroy
  has_many :policy_program_histories, dependent: :destroy
  belongs_to :representative
  belongs_to :account

  # Add Papertrail as history tracking
  has_paper_trail :on => [:update]

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
    where("policy_number = ?", "#{search}")
  end



  def self.to_csv
    attributes = self.column_names

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |policy|
        csv << attributes.map{ |attr| policy.send(attr) }
      end
    end
  end

  def calculate_experience
    self.transaction do

      @group_rating = GroupRating.find_by(process_representative: self.representative_number)

      self.manual_class_calculations.find_each do |manual_class|
        manual_class.calculate_payroll
      end

      @policy_total_four_year_payroll = self.manual_class_calculations.sum(:manual_class_four_year_period_payroll)
      @policy_total_expected_losses = self.manual_class_calculations.sum(:manual_class_expected_losses)
      @policy_total_current_payroll = self.manual_class_calculations.sum(:manual_class_current_estimated_payroll)

      if @policy_total_expected_losses <= 2000
        @credibility_row = BwcCodesCredibilityMaxLoss.where("expected_losses >= :expected_losses", expected_losses: @policy_total_expected_losses).min
        @credibility_row.credibility_group = 0
        @credibility_row.expected_losses = 0
        @credibility_row.credibility_percent = 0
        @credibility_row.group_maximum_value = 250000

      elsif @policy_total_expected_losses >= 1000000
        @credibility_row = BwcCodesCredibilityMaxLoss.find_by(expected_losses: 1000000)
      else
        @credibility_row = BwcCodesCredibilityMaxLoss.where("expected_losses >= :expected_losses", expected_losses: @policy_total_expected_losses).min
        @credibility_row = BwcCodesCredibilityMaxLoss.find_by(credibility_group: (@credibility_row.credibility_group - 1))
      end


      self.manual_class_calculations.find_each do |manual_class|
        manual_class.calculate_limited_losses(@credibility_row.credibility_group)
      end

      @policy_total_limited_losses = self.manual_class_calculations.sum(:manual_class_limited_losses)

      self.claim_calculations.find_each do |claim|
        claim.recalculate_experience(@credibility_row.group_maximum_value)
      end

      @claims = self.claim_calculations.where("claim_injury_date >= :experience_period_lower_date and claim_injury_date <= :experience_period_upper_date",  experience_period_lower_date: @group_rating.experience_period_lower_date, experience_period_upper_date: @group_rating.experience_period_upper_date)

      if @claims.empty?
        @policy_total_modified_losses_group_reduced = 0
        @policy_total_modified_losses_individual_reduced = 0
        @policy_group_ratio = 0
        @policy_total_claims_count = 0
      else
        @policy_total_modified_losses_group_reduced = @claims.sum(:claim_modified_losses_group_reduced)
        @policy_total_modified_losses_individual_reduced = @claims.sum(:claim_modified_losses_individual_reduced)
        @policy_total_claims_count = @claims.count
        @policy_group_ratio =
        if @policy_total_expected_losses == 0.0
          0
        else
          (@policy_total_modified_losses_group_reduced / @policy_total_expected_losses).round(6)
        end
      end

      @policy_individual_total_modifier =
          if @policy_total_limited_losses == 0
            0
          else
            (((@policy_total_modified_losses_individual_reduced - @policy_total_limited_losses ) / @policy_total_limited_losses) * @credibility_row.credibility_percent).round(6)
          end

     @policy_individual_experience_modified_rate = (@policy_individual_total_modifier + 1).round(6)

     self.update_attributes(
       policy_total_modified_losses_group_reduced: @policy_total_modified_losses_group_reduced, policy_total_modified_losses_individual_reduced: @policy_total_modified_losses_individual_reduced, policy_total_claims_count: @policy_total_claims_count,
       policy_individual_total_modifier: @policy_individual_total_modifier,
       policy_individual_experience_modified_rate: @policy_individual_experience_modified_rate,
       policy_group_ratio: @policy_group_ratio,
       policy_total_expected_losses: @policy_total_expected_losses,
       policy_total_four_year_payroll: @policy_total_four_year_payroll,
       policy_total_current_payroll: @policy_total_current_payroll,
       policy_credibility_percent: @credibility_row.credibility_percent,
       policy_credibility_group: @credibility_row.credibility_group,
       policy_total_limited_losses: @policy_total_limited_losses,
       policy_maximum_claim_value: @credibility_row.group_maximum_value)

   end # transaction end
  end

  def calculate_premium
    self.transaction do
    #  need policy_individual_experience_modified_rate, administrative_rate for manual_class
      @administrative_rate = (1 + BwcCodesConstantValue.find_by(name: 'administrative_rate', completed_date: nil).rate )

      self.manual_class_calculations.find_each do |manual_class_calculation|
        manual_class_calculation.calculate_premium(self.policy_individual_experience_modified_rate, @administrative_rate )
      end

      @policy_total_standard_premium = self.manual_class_calculations.sum(:manual_class_standard_premium)

      @collection = self.manual_class_calculations.pluck(:manual_class_industry_group).uniq

      @highest_industry_group = {industry_group: @collection.first, standard_premium: self.manual_class_calculations.where(manual_class_industry_group: @collection.first).sum(:manual_class_standard_premium)}

      @collection.each do |c|
        if self.manual_class_calculations.where(manual_class_industry_group: c).sum(:manual_class_standard_premium) > @highest_industry_group[:standard_premium]
          @highest_industry_group = {industry_group: c, standard_premium: self.manual_class_calculations.where(manual_class_industry_group: c).sum(:manual_class_standard_premium)}
        end
      end


    @policy_total_individual_premium =   self.manual_class_calculations.sum(:manual_class_estimated_individual_premium)


    self.update_attributes(policy_total_individual_premium: @policy_total_individual_premium, policy_industry_group: @highest_industry_group[:industry_group], policy_total_standard_premium: @policy_total_standard_premium)


    end #transaction
  end
end
