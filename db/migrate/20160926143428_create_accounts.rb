class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :representative, index: true, foreign_key: true
      t.string    :name
      t.integer   :policy_number_entered
      t.string    :street_address
      t.string    :street_address_2
      t.string    :city
      t.string    :state
      t.string    :zip_code
      t.bigint    :business_phone_number
      t.string    :business_email_address
      t.string    :website_url
      t.float     :group_fees
      t.float     :group_dues
      t.float     :total_costs
      t.integer   :status, default: 0
      t.string    :federal_identification_number
      t.date      :cycle_date
      t.date      :request_date
      t.boolean   :quarterly_request
      t.boolean   :weekly_request


      t.timestamps null: false
    end
  end
end
