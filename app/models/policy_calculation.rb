class PolicyCalculation < ActiveRecord::Base

  has_many :manual_class_calculations, dependent: :destroy
  has_many :claim_calculations, dependent: :destroy
  belongs_to :representative
  belongs_to :account

  def self.update_or_create(attributes)
    assign_or_new(attributes).save
  end

  def self.assign_or_new(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj
  end

  def self.search(search)
    where("policy_number = ?", "#{search}")
  end

  def fee_calculation
      if self.policy_total_individual_premium.nil? || self.policy_total_group_savings.nil? || self.representative_number != 219406
        return
      end
      if self.group_rating_tier.nil?
        fee = (self.policy_total_individual_premium * 0.035)
        self.update_attribute(:policy_group_fees, fee)
      elsif self.group_rating_tier < -0.35
        fee = (self.policy_total_group_savings * 0.0415)
        self.update_attribute(:policy_group_fees, fee)
      else
        fee = (self.policy_total_individual_premium * 0.0275)
        self.update_attribute(:policy_group_fees, fee)
      end
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


end
