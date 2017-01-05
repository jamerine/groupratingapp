class QuotesController < ApplicationController

  def new
    @account = Account.find(params[:account_id])
    @quote = Quote.new
    @program_types = Quote.program_types
    @statuses = Quote.statuses
    @current_date = Date.current
  end

  def create
    @account = Account.find(params[:quote][:account_id])
    if !@account.quote.nil?
      @account.quote.destroy!
    end
    @quote = Quote.new(quote_params)
    if @quote.save
      redirect_to edit_quote_path(@quote), notice: "Quote successfully created"
    else
      render :new
    end
  end

  def show
    @quote = Quote.find(params[:id])
    @account = @quote.account
  end

  def edit
    @quote = Quote.find(params[:id])
    @account = @quote.account
    @program_types = Quote.program_types
    @statuses = Quote.statuses
  end

  def update
    @quote = Quote.find(params[:id])
    @quote.assign_attributes(quote_params)
    if @quote.save
      redirect_to @quote.account, notice: "Quote was successfully saved."
    else
      flash.now[:alert] = "Error saving account. Please try again."
      render :edit
    end
  end

  def destroy
    @quote = Quote.find(params[:id])
    @account = @quote.account
    if @quote.destroy
      redirect_to @account, notice: "Quote was successfully deleted."
    else
      redirect_to @quote, notice: "Quote was was not deleted.  Please try again."
    end
  end

  private

  def quote_params
    params.require(:quote).permit(:account_id, :program_type, :fees, :amount, :invoice_number, :quote_date, :effective_start_date, :effective_end_date, :status, :ac2_received_on, :ac26_received_on, :u53_received_on, :contract_signed_on, :questionnaire_received_on)
  end

end
