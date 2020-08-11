class QuotePolicy < ApplicationPolicy

  def new?
     user.admin? || user.read_only? || user.general? || user.manager?
  end

  def index?
     user.admin? || user.read_only? || user.general? || user.manager?
  end

  def create?
     user.admin? || user.read_only? || user.general? || user.manager?
  end

  def edit?
     user.admin? || user.read_only? || user.general? || user.manager?
  end

  def update?
     user.admin? || user.read_only? || user.general? || user.manager?
  end

  def destroy?
    user.admin? || user.read_only? || user.general? || user.manager?
  end

  def edit_quote_accounts?
    user.admin? || user.read_only? || user.general? || user.manager?
  end

  def group_rating_report?
     user.admin? || user.read_only? || user.general? || user.manager?
  end

  def generate_account_quotes?
    user.admin? || user.read_only? || user.general? || user.manager?
  end

  def delete_all_quotes?
    user.admin?
  end

  def view_group_rating_quote?
     user.admin? || user.read_only? || user.general? || user.manager?
  end

  def create_group_retro?
    user.admin? || user.read_only? || user.general? || user.manager?
  end


end
