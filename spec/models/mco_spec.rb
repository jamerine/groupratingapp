# == Schema Information
#
# Table name: mcos
#
#  id         :integer          not null, primary key
#  deleted_at :datetime
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  bwc_mco_id :integer
#
# Indexes
#
#  index_mcos_on_deleted_at  (deleted_at)
#

require 'rails_helper'

RSpec.describe Mco, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
