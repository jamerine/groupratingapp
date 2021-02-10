class ClaimNotesImport
  include Sidekiq::Worker

  sidekiq_options queue: :import_file

  def perform(notes_hash, representative_number, user_id)
    notes_hash = notes_hash.with_indifferent_access

    if representative_number.present?
      @category                    = ClaimNoteCategory.find_by(title: notes_hash[:category_name].titleize)
      @note                        = ClaimNote.find_or_initialize_by(representative_number: representative_number,
                                                                     claim_number:          notes_hash[:claim_number]&.strip,
                                                                     policy_number:         notes_hash[:policy_number]&.strip.to_i,
                                                                     title:                 notes_hash[:title])
      @note.title                  ||= 'No Title'
      @note.claim_note_category_id = @category&.id
      @note.user_id                = user_id
      @note.body                   = notes_hash[:body]
      @note.date                   = DateTime.strptime(notes_hash[:updated_at], '%m/%d/%y %H:%M')

      @note.save!
    end
  end
end
