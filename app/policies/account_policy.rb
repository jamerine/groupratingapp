class AccountPolicy < ApplicationPolicy

  def new?
    user.admin? || user.read_only? || user.general? || user.manager?
  end

  def create?
    new? || user.read_only? || user.general? || user.manager?
  end

  def edit?
    new? || user.read_only? || user.general? || user.manager?
  end

  def update?
    new? || user.read_only? || user.general? || user.manager?
  end

  def edit_group_retro?
    new?
  end

  def edit_group_rating
    new?
  end


end
