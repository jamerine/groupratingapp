class MiraClicdProcess
  include Sidekiq::Worker
  sidekiq_options queue: :mira_clicd_process, retry: 1

  def perform
    Representative.all.find_each do |representative|
      ImportMiraFilesProcess.perform_async(representative.representative_number, representative.abbreviated_name)
      ImportMiraFilesProcess.perform_async(representative.representative_number, representative.abbreviated_name, true)
      ImportClicdFilesProcess.perform_async(representative.representative_number, representative.abbreviated_name)
    end
  end
end