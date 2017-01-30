class Representative < ActiveRecord::Base
  has_many :imports, dependent: :destroy
  has_many :group_ratings, dependent: :destroy
  has_many :policy_calculations, dependent: :destroy
  has_many :manual_class_calculations, :through => :policy_calculations
  has_many :accounts, dependent: :destroy
  has_many :policy_coverage_status_histories, dependent: :destroy
  has_many :policy_program_histories, dependent: :destroy
  has_many :group_rating_rejections, dependent: :destroy
  has_many :group_rating_exceptions, dependent: :destroy

  has_many :representatives_users
  has_many :users, through: :representatives_users

  def self.options_for_select
    order('LOWER(abbreviated_name)').map { |e| [e.abbreviated_name, e.id] }
  end

end
