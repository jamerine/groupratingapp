# == Schema Information
#
# Table name: accounts_mcos
#
#  id                      :integer          not null, primary key
#  deleted_at              :datetime
#  relationship_start_date :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  account_id              :integer
#  mco_id                  :integer
#
# Indexes
#
#  index_accounts_mcos_on_deleted_at  (deleted_at)
#

require 'rails_helper'

RSpec.describe AccountsMco, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
