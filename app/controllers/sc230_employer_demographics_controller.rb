class Sc230EmployerDemographicsController < ApplicationController
  def index
    @sc230_employer_demographics = Sc230EmployerDemographics.all
    @sc230_employer_demographics_count = Sc230EmployerDemographics.count
    @sc230_claim_medical_payments = Sc230ClaimMedicalPayments.all
    @sc230_claim_medical_payments_count = Sc230ClaimMedicalPayments.count
    @sc230_claim_indemnity_awards = Sc230ClaimIndemnityAwards.all
    @sc230_claim_indemnity_awards_count = Sc230ClaimIndemnityAwards.count

  end

  def parse
    Sc230EmployerDemographic.parse_table
    # redirect_to root_url, notice: "Step 2 Completed: SC230 parsed into 3 different SC230 Records. Process Completed."
    redirect_to parse_index_path, notice: "The Sc230 has been parsed"
  end
end
