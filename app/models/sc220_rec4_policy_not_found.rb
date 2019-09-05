# == Schema Information
#
# Table name: sc220_rec4_policy_not_founds
#
#  id                       :integer          not null, primary key
#  representative_number    :integer
#  representative_type      :integer
#  description              :string
#  record_type              :integer
#  request_type             :integer
#  policy_type              :string
#  policy_number            :integer
#  business_sequence_number :integer
#  error_message            :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class Sc220Rec4PolicyNotFound < ActiveRecord::Base
end
