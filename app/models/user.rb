# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  deleted_at             :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default(2)
#  sign_in_count          :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  acts_as_paranoid

  has_many :representatives_users, dependent: :destroy
  has_many :representatives, through: :representatives_users
  has_many :notes

  validates_presence_of :role, :first_name, :last_name

  enum role: [:admin, :client, :manager, :general, :read_only]

  def full_name
    "#{first_name} #{last_name}"
  end

  def representative_logo_filename
    representative_to_use.logo_filename
  end

  def representative_logo_url
    representative_to_use.logo_url
  end

  private

  def representative_to_use
    self.representatives.sort_by(&:id).first || Representative.default_representative
  end
end
