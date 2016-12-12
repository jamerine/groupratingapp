class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :prefix, default: 0
      t.string :first_name
      t.string :middle_initial
      t.string :last_name
      t.string :suffix
      t.string :email_address
      t.string :phone_number
      t.string :phone_extension
      t.string :mobile_phone
      t.string :fax_number
      t.integer :contact_type, default: 1
      t.string :salesforce_id
      t.string :title
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country

      t.string :created_by
      t.string :updated_by

      t.timestamps null: false
    end
  end
end
