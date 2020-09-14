class AllRepresentativesProcess
  require 'progress_bar/core_ext/enumerable_with_progress'
  include Sidekiq::Worker
  sidekiq_options queue: :all_representatives_process

  def perform
    # Only do this at the end because it takes an additional 2-3 hours
    Representative.all.find_each do |representative|
      # Go ahead and redo calculations since sometimes they aren't accurate
      RepresentativeAllAccountRating.perform_async(representative.id)

      # ImportMiraFilesProcess.perform_in((5 * representative.id).minutes, representative.representative_number, representative.abbreviated_name)
      # ImportClicdFilesProcess.perform_async(representative.representative_number, representative.abbreviated_name)
    end
  end
end
