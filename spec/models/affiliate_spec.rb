# == Schema Information
#
# Table name: affiliates
#
#  id                :integer          not null, primary key
#  first_name        :string
#  last_name         :string
#  role              :integer          default(0)
#  email_address     :string
#  salesforce_id     :string
#  representative_id :integer
#  internal_external :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  external_id       :string
#  company_name      :string
#

require 'rails_helper'

RSpec.describe Affiliate, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
