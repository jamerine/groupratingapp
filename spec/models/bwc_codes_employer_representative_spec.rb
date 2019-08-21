# == Schema Information
#
# Table name: bwc_codes_employer_representatives
#
#  id                    :integer          not null, primary key
#  rep_id                :integer
#  employer_rep_name     :string
#  rep_id_text           :string
#  representative_number :integer
#  created_at            :datetime
#  updated_at            :datetime
#

require 'rails_helper'

RSpec.describe BwcCodesEmployerRepresentative, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
