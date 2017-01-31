class AccountPolicy < ApplicationPolicy

  def new?
    user.admin?
  end

  def create?
    new?
  end

  def edit?
    new?
  end

  def update?
    new?
  end

  def edit_group_retro?
    new?
  end

  def edit_group_rating
    new?
  end


end
