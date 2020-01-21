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

FactoryBot.define do
  factory :contact do
    
  end
end
