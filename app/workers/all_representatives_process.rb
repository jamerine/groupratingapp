class AllRepresentativesProcess
  require 'progress_bar/core_ext/enumerable_with_progress'
  include Sidekiq::Worker
  sidekiq_options queue: :all_representatives_process

  def perform
    Representative.all.find_each do |representative|
      # Go ahead and redo calculations since sometimes they aren't accurate
      RepresentativeAllAccountRating.perform_async(representative.id)
    end
  end
end
