namespace :notes do
  task create_and_assign_categories: :environment do
    Note.categories.each do |category|
      NoteCategory.find_or_create_by(title: category[0].titleize)
    end

    Note.all.each do |note|
      note.update_attribute(:category_id, NoteCategory.find_by(title: note.category&.titleize)&.id)
    end

    puts 'Added Notes and updated Note categories'
  end
end