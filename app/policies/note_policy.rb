class NotePolicy < ApplicationPolicy

  def edit?
    user == record.user
  end

  def destroy?
    user == record.user
  end

end
