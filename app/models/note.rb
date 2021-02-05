# == Schema Information
#
# Table name: notes
#
#  id           :integer          not null, primary key
#  attachment   :string
#  category     :integer
#  date         :datetime
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
  belongs_to :note_category, foreign_key: :category_id
  has_one :representative, through: :account

  enum category: [:billing, :claims, :general, :group_rating, :group_retro, :policy_admin, :sales]

  validates :note_category, presence: true
  validates :user, presence: true
  validates :account, presence: true

  mount_uploader :attachment, NoteUploader
  validate :attachment_size_validation

  delegate :policy_number_entered, to: :account, prefix: false, allow_nil: false

  scope :user_filter, -> (user) { where(user: user) }
  scope :category_filter, -> (category) { where(category: category) }
  scope :pinned, -> { order(is_pinned: :asc) }
  scope :retention_notes, -> { pinned.where(is_retention: true) }
  scope :group_notes, -> { pinned.where(is_group: true) }
  scope :policy_notes, -> { pinned.where(is_retention: false, is_group: false) }
  scope :by_representative, -> (rep_id) { includes(:representative).where(representatives: { id: rep_id }) }

  def order_date
    self.date || self.created_at
  end

  private

  def attachment_size_validation
    errors[:image] << "Should be less than 3 MB" if attachment.size > 1.megabytes
  end
end
