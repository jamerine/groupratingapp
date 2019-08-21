# == Schema Information
#
# Table name: representatives_users
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  representative_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe RepresentativesUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
