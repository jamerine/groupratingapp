class RepresentativePolicy < ApplicationPolicy

  def users_management?
    user.admin?
  end

  def conversion?
    user.email == 'jason@dittoh.com' || user.email == 'paul@dittoh.com'
  end


end
