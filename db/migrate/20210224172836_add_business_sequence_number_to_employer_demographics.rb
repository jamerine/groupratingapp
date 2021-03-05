class AddBusinessSequenceNumberToEmployerDemographics < ActiveRecord::Migration
  def change
    add_column :employer_demographics, :business_sequence_number, :integer, default: 0, null: true
  end
end
