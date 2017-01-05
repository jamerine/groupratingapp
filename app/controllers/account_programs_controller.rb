class AccountProgramsController < ApplicationController

  def new
    @quote = Quote.find(params[:quote_id])
    @account = @quote.account
    @account_program = AccountProgram.new
  end

  def create
    @account = Account.find(params[:account_program][:account_id])
    @account_program = AccountProgram.new(account_program_params)
    if @account_program.save
      redirect_to @account, notice: "#{ @account.name } is now enrolled in #{ @account_program.program_type.humanize } "
    else
      redirect_to edit_quote_path(@account.quote), alert: "#{@account_program} was not enrolled in an Account Program.  Please try again."
    end
  end


  private

  def account_program_params
    params.require(:account_program).permit(:account_id, :program_type, :fees_amount, :paid_amount, :invoice_number, :quote_date, :quote_sent_date, :quote_generated, :effective_start_date, :effective_end_date, :status, :ac2_signed_on, :ac26_signed_on, :u153_signed_on, :contract_signed_on, :questionnaire_signed_on, :invoice_received_on, :program_paid_on, :group_retro_group_number, :group_rating_group_number)
  end

end
