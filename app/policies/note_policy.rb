class NotePolicy < ApplicationPolicy

  def edit?
    user.admin? || user == record.user
  end

  def destroy?
    user.admin? || user == record.user
  end

end
