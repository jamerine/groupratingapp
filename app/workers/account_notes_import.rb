class AccountNotesImport
  include Sidekiq::Worker

  sidekiq_options queue: :import_file

  def perform(notes_hash, representative_id, user_id)
    notes_hash = notes_hash.with_indifferent_access
    account    = Account.find_by(representative_id: representative_id, policy_number_entered: notes_hash[:policy_number])

    if account.present?
      @category         = NoteCategory.find_by(title: notes_hash[:category_name].titleize) || NoteCategory.find_by(title: 'General')
      @note             = Note.find_by(account_id: account.id, title: notes_hash[:title]) || Note.new(account_id: account.id, title: notes_hash[:title])
      @note.category_id = @category.id
      @note.description = notes_hash[:description]
      @note.user_id     = user_id

      @note.save!
    end
  end
end


