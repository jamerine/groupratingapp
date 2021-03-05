class RemoveRepresentativeFromEmployerDemographics < ActiveRecord::Migration
  def change
    remove_column :employer_demographics, :representative_id
  end
end
