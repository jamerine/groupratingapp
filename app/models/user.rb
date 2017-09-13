class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :representatives_users
  has_many :representatives, through: :representatives_users
  has_many :notes


  enum role: [:admin, :client, :general, :read_only]


  def full_name
    "#{first_name} #{last_name}"
  end
end
