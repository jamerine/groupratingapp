# == Schema Information
#
# Table name: notes
#
#  id           :integer          not null, primary key
#  attachment   :string
#  category     :integer
#  date         :datetime
#  deleted_at   :datetime
#  description  :text
#  is_group     :boolean          default(FALSE)
#  is_pinned    :boolean          default(FALSE)
#  is_retention :boolean          default(FALSE)
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :integer
#  category_id  :integer
#  user_id      :integer
#
# Indexes
#
#  index_notes_on_account_id  (account_id)
#  index_notes_on_deleted_at  (deleted_at)
#  index_notes_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe Note, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
