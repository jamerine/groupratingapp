class Contact < ActiveRecord::Base
  has_many :accounts_contacts, dependent: :destroy
  has_many :accounts, through: :accounts_contacts

  # before_save {self.first_name = first_name.downcase.titleize}
  # before_save {self.middle_initial = middle_initial.downcase.titleize}
  # before_save {self.last_name = last_name.downcase.titleize}
  # before_save {self.email_address = email_address.downcase}
  # before_save :format_phone_number


  enum contact_type: [:billing, :claims, :general, :hr, :owner, :tpa]
  enum prefix: [:dr, :miss, :mr, :mrs, :ms]

  def full_name
    "#{first_name} #{last_name}"
  end

  def formal_name
      "#{prefix}. #{first_name} #{middle_initial} #{last_name}, #{suffix}"
  end

end
