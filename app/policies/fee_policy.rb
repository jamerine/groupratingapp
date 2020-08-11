class FeePolicy < Struct.new(:user, :fee)

  def index?
    user.admin? || user.read_only? || user.general? || user.manager?
  end

  def edit_individual?
     user.admin? || user.read_only? || user.general? || user.manager?
  end

  def fee_accounts?
     user.admin? || user.read_only? || user.general? || user.manager?
  end

  def update_individual?
     user.admin? || user.read_only? || user.general? || user.manager?
  end


end
