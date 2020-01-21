# == Schema Information
#
# Table name: representatives_users
#
#  id                :integer          not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  representative_id :integer
#  user_id           :integer
#
# Indexes
#
#  index_representatives_users_on_representative_id  (representative_id)
#  index_representatives_users_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (representative_id => representatives.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :representatives_user do
    
  end
end
