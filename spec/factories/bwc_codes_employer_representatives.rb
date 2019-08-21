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

FactoryGirl.define do
  factory :bwc_codes_employer_representative do
    
  end
end
