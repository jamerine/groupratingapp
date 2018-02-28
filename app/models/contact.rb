class Contact < ActiveRecord::Base
  has_many :accounts_contacts, dependent: :destroy
  has_many :accounts, through: :accounts_contacts


  enum prefix: [:dr, :miss, :mr, :mrs, :ms]

  def full_name
    "#{first_name} #{last_name}"
  end

  def formal_name
      "#{prefix}. #{first_name} #{middle_initial} #{last_name}, #{suffix}"
  end

end
