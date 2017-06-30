class QuotePolicy < ApplicationPolicy

  def new?
     user.admin? || user.read_only?
  end

  def index?
     user.admin?
  end

  def create?
     user.admin? || user.read_only?
  end

  def edit?
     user.admin? || user.read_only?
  end

  def update?
     user.admin? || user.read_only?
  end

  def destroy?
    user.admin?
  end

  def edit_quote_accounts?
    user.admin?
  end

  def group_rating_report?
     user.admin? || user.read_only?
  end

  def generate_account_quotes?
    user.admin?
  end

  def delete_all_quotes?
    user.admin?
  end

  def view_group_rating_quote?
     user.admin? || user.read_only?
  end

  def create_group_retro?
    user.admin? || user.read_only?
  end


end
