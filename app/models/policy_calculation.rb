class PolicyCalculation < ActiveRecord::Base

  has_many :manual_class_calculations, dependent: :destroy
  has_many :claim_calculations, dependent: :destroy
  has_many :policy_coverage_status_histories, dependent: :destroy
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


end
