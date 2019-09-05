# == Schema Information
#
# Table name: bwc_group_accept_reject_lists
#
#  id            :integer          not null, primary key
#  policy_number :integer
#  name          :string
#  tpa           :string
#  bwc_rep_id    :string
#  created_at    :datetime
#  updated_at    :datetime
#

FactoryGirl.define do
  factory :bwc_group_accept_reject_list do
    
  end
end
