class AccountNotesImport
  include Sidekiq::Worker

  sidekiq_options queue: :import_file

  def perform(notes_hash, representative_id, user_id)
    notes_hash = notes_hash.with_indifferent_access
    account    = Account.find_by_rep_and_policy(representative_id, notes_hash[:policy_number].to_i)

    if account.present?
      @category          = NoteCategory.find_by(title: notes_hash[:category_name].titleize) || NoteCategory.find_by(title: 'General')
      @note              = Note.find_by(account_id: account.id, title: notes_hash[:title]) || Note.new(account_id: account.id, title: notes_hash[:title])
      @note.category_id  = @category.id
      @note.description  = notes_hash[:description]
      @note.user_id      = user_id
      @note.date         = DateTime.strptime(notes_hash[:updated_at], '%m/%d/%y %H:%M')
      @note.is_group     = notes_hash[:group]&.to_i == 1
      @note.is_retention = notes_hash[:retention]&.to_i == 1

      @note.save
    end
  end
end


