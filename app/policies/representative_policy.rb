class RepresentativePolicy < ApplicationPolicy

  def show?
    user.admin? || user.read_only? || user.general?
  end

  def edit?
    user.admin? || user.read_only? || user.general?
  end

  def update?
    user.admin? || user.read_only? || user.general?
  end

  def all_quote_process?
    user.admin? || user.read_only? || user.general?
  end

  def all_quote_process?
    user.admin? || user.read_only? || user.general?
  end

  def zip_file?
    user.admin? || user.read_only? || user.general?
  end

  def edit_global_dates?
    user.admin?
  end

  def fee_calculations?
    user.admin? || user.read_only? || user.general?
  end

  def users_management?
    user.admin?
  end

  def export_accounts?
    user.admin? || user.read_only? || user.general?
  end

  def export_manual_classes?
    user.admin? || user.read_only? || user.general?
  end

  def export_159_request_weekly?
    user.admin? || user.read_only? || user.general?
  end

  def filter_export_159_request_weekly?
    user.admin? || user.read_only? || user.general?
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




end
