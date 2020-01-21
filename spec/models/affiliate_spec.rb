# == Schema Information
#
# Table name: affiliates
#
#  id                :integer          not null, primary key
#  company_name      :string
#  email_address     :string
#  first_name        :string
#  internal_external :integer          default(0)
#  last_name         :string
#  role              :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  external_id       :string
#  representative_id :integer
#  salesforce_id     :string
#
# Indexes
#
#  index_affiliates_on_representative_id  (representative_id)
#
# Foreign Keys
#
#  fk_rails_...  (representative_id => representatives.id)
#

require 'rails_helper'

RSpec.describe Affiliate, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
