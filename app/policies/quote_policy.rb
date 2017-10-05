class QuotePolicy < ApplicationPolicy

  def new?
     user.admin? || user.read_only? || user.general?
  end

  def index?
     user.admin? || user.read_only? || user.general?
  end

  def create?
     user.admin? || user.read_only? || user.general?
  end

  def edit?
     user.admin? || user.read_only? || user.general?
  end

  def update?
     user.admin? || user.read_only? || user.general?
  end

  def destroy?
    user.admin? || user.read_only? || user.general?
  end

  def edit_quote_accounts?
    user.admin? || user.read_only? || user.general?
  end

  def group_rating_report?
     user.admin? || user.read_only? || user.general?
  end

  def generate_account_quotes?
    user.admin? || user.read_only? || user.general?
  end

  def delete_all_quotes?
    user.admin?
  end

  def view_group_rating_quote?
     user.admin? || user.read_only? || user.general?
  end

  def create_group_retro?
    user.admin? || user.read_only? || user.general?
  end


end
