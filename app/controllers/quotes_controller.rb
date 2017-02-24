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
    @program_types = Quote.program_types
    @quote = Quote.new(quote_params)
    @type = @program_types[params[:quote][:program_type]]
    @current_quote = @account.quotes.where(program_type: @type)
    if !@current_quote.empty?
      @current_quote.destroy_all
    end
    if @quote.save
      @quote.generate_invoice_number
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

  def group_rating_report
    @quote = Quote.find(params[:quote_id])
    @account = @quote.account
    @policy_calculation = @account.policy_calculation
    respond_to do |format|
      format.html
      format.pdf do
        pdf = GroupRatingQuote.new(@quote, @account, @policy_calculation, view_context)
        send_data pdf.render, filename: "#{ @account.policy_number_entered }_quote_#{ @quote.id }.pdf",
                              type: "application/pdf",
                              disposition: "inline"
        # pdf.render_file "app/reports/#{ @account.policy_number_entered }_quote_#{ @quote.id }.pdf"
      end
    end
    # redirect_to edit_quote_path(@quote), notice: "Quote Generated"
  end

  private

  def quote_params
    params.require(:quote).permit(:account_id, :program_type, :fees, :amount, :group_code, :invoice_number, :quote_date, :quote_sent_date, :effective_start_date, :effective_end_date, :status, :ac2_signed_on, :ac26_signed_on, :u153_signed_on, :contract_signed_on, :questionnaire_signed_on, :questionnaire_question_1, :questionnaire_question_2, :questionnaire_question_3, :questionnaire_question_4, :questionnaire_question_5)
  end

end
