class AddBusinessStreetAddress2ToEmployerDemographics < ActiveRecord::Migration
  def change
    add_column :employer_demographics, :business_street_address_2, :string, null: true
  end
end
