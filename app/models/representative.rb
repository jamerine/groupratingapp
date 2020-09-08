# == Schema Information
#
# Table name: representatives
#
#  id                                :integer          not null, primary key
#  abbreviated_name                  :string
#  bwc_quote_completion_date         :date
#  company_name                      :string
#  current_payroll_period_lower_date :date
#  current_payroll_period_upper_date :date
#  current_payroll_year              :integer
#  email_address                     :string
#  experience_date                   :date
#  experience_period_lower_date      :date
#  experience_period_upper_date      :date
#  fax_number                        :string
#  footer                            :string
#  group_dues                        :string
#  group_fees                        :string
#  internal_quote_completion_date    :date
#  location_address_1                :string
#  location_address_2                :string
#  location_city                     :string
#  location_state                    :string
#  location_zip_code                 :string
#  logo                              :string
#  mailing_address_1                 :string
#  mailing_address_2                 :string
#  mailing_city                      :string
#  mailing_state                     :string
#  mailing_zip_code                  :string
#  phone_number                      :string
#  president                         :string
#  president_first_name              :string
#  president_last_name               :string
#  program_year                      :integer
#  program_year_lower_date           :date
#  program_year_upper_date           :date
#  quote_year                        :integer
#  quote_year_lower_date             :date
#  quote_year_upper_date             :date
#  representative_number             :integer
#  signature                         :string
#  toll_free_number                  :string
#  zip_file                          :string
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#

class Representative < ActiveRecord::Base
  has_many :imports, dependent: :destroy
  has_many :group_ratings, dependent: :destroy
  has_many :policy_calculations, dependent: :destroy
  has_many :manual_class_calculations, through: :policy_calculations
  has_many :accounts, dependent: :destroy
  has_many :policy_coverage_status_histories, dependent: :destroy
  has_many :policy_program_histories, dependent: :destroy
  has_many :group_rating_rejections, dependent: :destroy
  has_many :group_rating_exceptions, dependent: :destroy
  has_many :representatives_users
  has_many :users, through: :representatives_users

  mount_uploader :logo, LogoUploader
  mount_uploader :zip_file, RepresentativeUploader
  mount_uploader :signature, SignatureUploader
  mount_uploader :president, PresidentUploader
  mount_uploader :footer, FooterUploader

  scope :default_representative, -> { find(1) }

  def self.options_for_select
    order('LOWER(representatives.abbreviated_name)').map { |e| [e.abbreviated_name, e.id] }
  end

  def full_location_address
    "#{self.location_address_1} #{self.location_city} #{self.location_state.upcase} #{self.location_zip_code}"
  end

  def president_full_name
    "#{ self.president_first_name } #{ self.president_last_name }"
  end

  def matrix?
    self.representative_number == 1740
  end

  def logo_filename
    logo_to_use.file.filename
  end

  def logo_url
    logo_to_use.url || ActionView::Helpers::AssetUrlHelper.asset_url('logo.png')
  end

  def logo_to_use
    logo? ? logo : self.class.default_representative.logo
  end
end
