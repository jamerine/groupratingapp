class Note < ActiveRecord::Base

  belongs_to :user
  belongs_to :account

  enum category: [:billing, :claims, :general, :group_rating, :group_retro, :policy_admin, :sales]

  validates :category, presence: true
  validates :description, presence: true
  validates :user, presence: true
  validates :account, presence: true

end
