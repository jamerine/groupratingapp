class PayrollCalculationPolicy < ApplicationPolicy

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def destroy?
    user.admin?
  end
  
end
