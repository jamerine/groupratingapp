class ClaimNotesImport
  include Sidekiq::Worker

  sidekiq_options queue: :import_file

  def perform(notes_hash, representative_id)
    notes_hash      = notes_hash.with_indifferent_access
    @representative = Representative.find_by(id: representative_id)

    if @representative.present?
      @category                    = ClaimNoteCategory.find_by(title: notes_hash[:category_name].titleize)
      @note                        = ClaimNote.find_by(representative_number: @representative.representative_number,
                                                       claim_number:          notes_hash[:claim_number],
                                                       policy_number:         notes_hash[:policy_number],
                                                       title:                 notes_hash[:title])
      @note                        ||= ClaimNote.new(representative_number: @representative.representative_number,
                                                     policy_number:         notes_hash[:policy_number],
                                                     claim_number:          notes_hash[:claim_number],
                                                     title:                 notes_hash[:title])
      @note.claim_note_category_id = @category&.id
      @note.body                   = notes_hash[:body]

      @note.save!
    end
  end
end
