class RepresentativePolicy < ApplicationPolicy

  def show?
    user.admin? || user.read_only? || user.general? || user.manager?
  end

  def edit?
    user.admin? || user.read_only? || user.general? || user.manager?
  end

  def update?
    user.admin? || user.read_only? || user.general? || user.manager?
  end

  def all_quote_process?
    user.admin? || user.read_only? || user.general? || user.manager?
  end

  def all_quote_process?
    user.admin? || user.read_only? || user.general? || user.manager?
  end

  def zip_file?
    user.admin? || user.read_only? || user.general? || user.manager?
  end

  def edit_global_dates?
    user.admin?
  end

  def fee_calculations?
    user.admin? || user.read_only? || user.general? || user.manager?
  end

  def users_management?
    user.admin?
  end

  def export_accounts?
    user.admin? || user.read_only? || user.general? || user.manager?
  end

  def export_manual_classes?
    user.admin? || user.read_only? || user.general? || user.manager?
  end

  def export_159_request_weekly?
    user.admin? || user.read_only? || user.general? || user.manager?
  end

  def filter_export_159_request_weekly?
    user.admin? || user.read_only? || user.general? || user.manager?
  end

  def conversion?
    user.email == 'jason@dittoh.com' || user.email == 'paul@dittoh.com'
  end

  def import_contact_process?
    user.admin?
  end

  def import_payroll_process?
    user.admin?
  end

  def import_claim_process?
    user.admin?
  end

  def all_account_group_rating?
    user.admin?
  end




end
