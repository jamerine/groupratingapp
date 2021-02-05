namespace :notes do
  task transfer_to_matrix: :environment do
    require 'progress_bar/core_ext/enumerable_with_progress'

    representative_arm    = Representative.find_by_representative_number(219406)
    representative_matrix = Representative.find_by_representative_number(1740)

    Note.by_representative(representative_arm.id).each_with_progress do |note|
      new_account = Account.find_by_rep_and_policy(representative_matrix.id, note.policy_number_entered)
      note.update_attribute(:account_id, new_account.id) if new_account.present?
    end

    puts 'Account Notes complete, now on to claim notes....'

    ClaimNote.by_representative(representative_arm.representative_number).each_with_progress { |claim| claim.update_attribute(:representative_number, representative_matrix.representative_number) }
  end
end