class FeePolicy < Struct.new(:user, :fee)

  def index?
    user.admin? || user.read_only? || user.general?
  end

  def edit_individual?
     user.admin? || user.read_only? || user.general?
  end

  def fee_accounts?
     user.admin? || user.read_only? || user.general?
  end

  def update_individual?
     user.admin? || user.read_only? || user.general?
  end


end
