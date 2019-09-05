# == Schema Information
#
# Table name: contacts
#
#  id              :integer          not null, primary key
#  prefix          :integer          default(0)
#  first_name      :string
#  middle_initial  :string
#  last_name       :string
#  suffix          :string
#  email_address   :string
#  phone_number    :string
#  phone_extension :string
#  mobile_phone    :string
#  fax_number      :string
#  salesforce_id   :string
#  title           :string
#  address_line_1  :string
#  address_line_2  :string
#  city            :string
#  state           :string
#  zip_code        :string
#  country         :string
#  created_by      :string
#  updated_by      :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Contact < ActiveRecord::Base
  has_many :accounts_contacts, dependent: :destroy
  has_many :accounts, through: :accounts_contacts


  enum prefix: [:dr, :miss, :mr, :mrs, :ms]

  def full_name
    "#{first_name} #{last_name}"
  end

  def formal_name
      "#{prefix}. #{first_name} #{middle_initial} #{last_name}, #{suffix}"
  end

end
