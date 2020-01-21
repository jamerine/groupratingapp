# == Schema Information
#
# Table name: notes
#
#  id          :integer          not null, primary key
#  attachment  :string
#  category    :integer
#  description :text
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :integer
#  user_id     :integer
#
# Indexes
#
#  index_notes_on_account_id  (account_id)
#  index_notes_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (user_id => users.id)
#

class Note < ActiveRecord::Base

  belongs_to :user
  belongs_to :account

  enum category: [:billing, :claims, :general, :group_rating, :group_retro, :policy_admin, :sales]

  validates :category, presence: true
  validates :description, presence: true
  validates :title, presence: true
  validates :user, presence: true
  validates :account, presence: true

  mount_uploader :attachment, NoteUploader
  validate :attachment_size_validation

  scope :user_filter, -> (user) { where user: user }
  scope :category_filter, -> (category) { where category: category }

  private

  def attachment_size_validation
    errors[:image] << "Should be less than 3 MB" if attachment.size > 1.megabytes
  end

end
