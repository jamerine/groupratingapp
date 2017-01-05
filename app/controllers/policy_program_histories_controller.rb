class PolicyProgramHistoriesController < ApplicationController

  def show
    @policy_program_history = PolicyProgramHistory.find(params[:id])

    @account = @policy_program_history.policy_calculation.account
  end

end
