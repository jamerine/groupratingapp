class Account < ActiveRecord::Base

  has_one :policy_calculation, dependent: :destroy
  belongs_to :representative

  enum status: [:active, :inactive, :predecessor, :prospect]

  def self.update_or_create(attributes)
    assign_or_new(attributes).save
  end

  def self.assign_or_new(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj
  end


end
