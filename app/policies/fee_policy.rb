class FeePolicy < Struct.new(:user, :fee)

  def index?
    user.admin?
  end

  def edit_individual?
     user.admin?
  end

  def fee_accounts?
     user.admin?
  end

  def update_individual?
     user.admin?
  end


end
