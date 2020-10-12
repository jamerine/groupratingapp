class ImportSc230Process
  include Sidekiq::Worker
  include ImportHelper
  sidekiq_options queue: :import_sc230_process, retry: 3

  def perform(representative_number, representative_abbreviated_name, file_url = nil)
    Sc220.delete_all
    Sc230.delete_all
    Sc220Rec1EmployerDemographic.delete_all
    Sc220Rec2EmployerManualLevelPayroll.delete_all
    Sc220Rec3EmployerArTransaction.delete_all
    Sc220Rec4PolicyNotFound.delete_all
    Sc230EmployerDemographic.delete_all
    Sc230ClaimMedicalPayment.delete_all
    Sc230ClaimIndemnityAward.delete_all

    import_single_file(file_url || "https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/SC230FILE", 'sc230s')
  end
end
