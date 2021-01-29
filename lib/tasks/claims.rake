namespace :claims do
  task update_non_at_fault: :environment do
    require 'progress_bar/core_ext/enumerable_with_progress'

    detail_records = DemocDetailRecord.where('non_at_fault IN (?)', %w[Y N])
    claims         = []

    puts "Loaded Detail Records....pulling Claims..."

    detail_records.each_with_progress { |democ_detail_record| claims << [democ_detail_record.non_at_fault, ClaimCalculation.select(:id).where(policy_number: democ_detail_record.policy_number, representative_number: democ_detail_record.representative_number).where('claim_number LIKE ?', "%#{democ_detail_record.claim_number.strip}%").first&.id] }
    claims = claims.compact.uniq

    puts "Claims pulled...updating Claims..."

    claims.each_with_progress do |claim_array|
      next unless claim_array[1].present?

      ClaimCalculation.find(claim_array[1]).update_attribute(:non_at_fault, claim_array[0])
    end

    puts 'Updated non at faults...'
  end
end
