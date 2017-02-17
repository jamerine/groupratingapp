class AccountProgramsController < ApplicationController

  def new
    @quote = Quote.find(params[:quote_id])
    @account = @quote.account
    @account_program = AccountProgram.new
  end

  def create
    @account = Account.find(params[:account_program][:account_id])
    @quote = Quote.find(params[:account_program][:quote_id])
    @account_program = AccountProgram.new(account_program_params)
    @current_account_program = @account.account_programs.find_by(effective_start_date: @account_program.effective_start_date, effective_end_date: @account_program.effective_end_date)
    if @current_account_program
      @current_account_program.destroy
    end
    if @account_program.save
      @quote.destroy
      redirect_to @account, notice: "#{ @account.name } is now enrolled in #{ @account_program.program_type.humanize } "
    else
      redirect_to edit_quote_path(@account.quote), alert: "#{@account_program} was not enrolled in an Account Program.  Please try again."
    end
  end

  def edit
    @account_program = AccountProgram.find(params[:id])
    @account = @account_program.account
  end

  def update
    @account_program = AccountProgram.find(params[:id])
    @account_program.assign_attributes(account_program_params)
    if @account_program.save
      redirect_to @account_program.account, notice: "Program was successfully saved."
    else
      flash.now[:alert] = "Error saving account program. Please try again."
      render :edit
    end
  end

  def destroy
    @account_program = AccountProgram.find(params[:id])
    if @account_program.destroy
      redirect_to @account_program.account
    else
      redirect_to :back
    end
  end

  def import_account_program_process

    CSV.foreach(params[:file].path, headers: true) do |row|
      hash = row.to_hash # exclude the price field
      AccountProgramImport.perform_async(hash)
    end

    redirect_to root_url, notice: "Account Programs imported."
  end



  private

  def account_program_params
    params.require(:account_program).permit(:account_id, :program_type, :group_code, :fees_amount, :paid_amount, :invoice_number, :quote_date, :quote_sent_date, :quote_generated, :effective_start_date, :effective_end_date, :status, :ac2_signed_on, :ac26_signed_on, :u153_signed_on, :contract_signed_on, :questionnaire_signed_on, :invoice_received_on, :program_paid_on, :group_retro_group_number, :group_rating_group_number, :check_number)
  end

end
