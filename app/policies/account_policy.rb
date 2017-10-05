class AccountPolicy < ApplicationPolicy

  def new?
    user.admin? || user.read_only? || user.general?
  end

  def create?
    new? || user.read_only? || user.general?
  end

  def edit?
    new? || user.read_only? || user.general?
  end

  def update?
    new? || user.read_only? || user.general?
  end

  def edit_group_retro?
    new?
  end

  def edit_group_rating
    new?
  end


end
