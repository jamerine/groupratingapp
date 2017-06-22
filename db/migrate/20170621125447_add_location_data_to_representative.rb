class AddLocationDataToRepresentative < ActiveRecord::Migration
  def change
    add_column :representatives, :location_address_1, :string
    add_column :representatives, :location_address_2, :string
    add_column :representatives, :location_city, :string
    add_column :representatives, :location_state, :string
    add_column :representatives, :location_zip_code, :string
    add_column :representatives, :mailing_address_1, :string
    add_column :representatives, :mailing_address_2, :string
    add_column :representatives, :mailing_city, :string
    add_column :representatives, :mailing_state, :string
    add_column :representatives, :mailing_zip_code, :string
    add_column :representatives, :phone_number, :string
    add_column :representatives, :toll_free_number, :string
    add_column :representatives, :fax_number, :string
    add_column :representatives, :email_address, :string
    add_column :representatives, :president_first_name, :string
    add_column :representatives, :president_last_name, :string
  end
end
