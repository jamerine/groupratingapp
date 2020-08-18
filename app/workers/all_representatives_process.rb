class AllRepresentativesProcess
  require 'progress_bar/core_ext/enumerable_with_progress'
  include Sidekiq::Worker
  sidekiq_options queue: :all_representatives_process

  def perform
    # Only do this at the end because it takes an additional 2-3 hours
    Representative.all.find_each do |representative|
      ImportMiraFilesProcess.perform_async(representative.representative_number, representative.abbreviated_name)
      ImportClicdFilesProcess.perform_async(representative.representative_number, representative.abbreviated_name)
    end
  end
end
