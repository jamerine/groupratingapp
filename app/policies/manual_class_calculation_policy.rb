class ManualClassCalculationPolicy < ApplicationPolicy

  def new?
    user.admin?
  end

  def create?
    new?
  end


end
