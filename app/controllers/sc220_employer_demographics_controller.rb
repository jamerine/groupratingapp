class Sc220EmployerDemographicsController < ApplicationController
  def index
    @sc220_rec1_employer_demographics = Sc220Rec1EmployerDemographic.all
    @sc220_rec1_employer_demographics_count = Sc220Rec1EmployerDemographic.count
    @sc220_rec2_employer_manual_level_payrolls = Sc220Rec2EmployerManualLevelPayroll.all
    @sc220_rec2_employer_manual_level_payrolls_count = Sc220Rec2EmployerManualLevelPayroll.count
    @sc220_rec3_employer_ar_transactions = Sc220Rec3EmployerArTransaction.all
    @sc220_rec3_employer_ar_transactions_count = Sc220Rec3EmployerArTransaction.count
    @sc220_rec4_policy_not_founds = Sc220Rec4PolicyNotFound.all
    @sc220_rec4_policy_not_founds_count = Sc220Rec4PolicyNotFound.count
  end

  def parse
    Sc220Rec1EmployerDemographic.parse_table
    # redirect_to root_url, notice: "Step 2 Completed: SC220 parsed into 4 different SC220 Records. Process Completed."
    redirect_to parse_index_path, notice: "The Sc220 has been parsed"
  end
end
