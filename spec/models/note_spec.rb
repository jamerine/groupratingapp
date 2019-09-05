# == Schema Information
#
# Table name: notes
#
#  id          :integer          not null, primary key
#  description :text
#  category    :integer
#  title       :string
#  attachment  :string
#  account_id  :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Note, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
