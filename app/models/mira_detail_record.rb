# == Schema Information
#
# Table name: mira_detail_records
#
#  id                       :integer          not null, primary key
#  representative_number    :integer
#  record_type              :integer
#  requestor_number         :integer
#  policy_number            :integer
#  business_sequence_number :integer
#  valid_policy_number      :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class MiraDetailRecord < ActiveRecord::Base
end
