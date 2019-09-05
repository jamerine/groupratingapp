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

require 'rails_helper'

RSpec.describe BwcGroupAcceptRejectList, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
