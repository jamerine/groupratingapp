class ImportMrempsProcess
  include Sidekiq::Worker
  include ImportHelper
  sidekiq_options queue: :import_mremps_process, retry: 3

  def perform(representative_number, representative_abbreviated_name, file_url = nil)
    Mremp.delete_all
    MrempEmployeeExperiencePolicyLevel.delete_all
    MrempEmployeeExperienceManualClassLevel.delete_all
    MrempEmployeeExperienceClaimLevel.delete_all

    import_single_file(file_url || "https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/MREMPFILE", 'mremps')
  end
end
