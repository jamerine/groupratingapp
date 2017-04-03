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
    if @quote.save
      @quote.generate_invoice_number
      ##### ADDED THIS PART
      pdf = GroupRatingQuote.new(@quote, @account, @account.policy_calculation, view_context)
      uploader = QuoteUploader.new
      tmpfile = Tempfile.new(["#{ @account.policy_number_entered }_quote_#{ @quote.id }", '.pdf'])
      tmpfile.binmode
      tmpfile.write (pdf.render)
      # uploader.store! tmpfile
      @quote.quote_generated = tmpfile
      tmpfile.close
      tmpfile.unlink
      @quote.save!
      #######
      redirect_to edit_quote_path(@quote), notice: "Quote successfully created"
    else
      render :new
    end
  end

  def index
    @representative = Representative.find(params[:representative_id])
    @statuses = Account.statuses
    @group_rating_tiers = BwcCodesIndustryGroupSavingsRatioCriterium.all.order(market_rate: :asc).pluck(:market_rate).uniq
    @group_retro_tiers = BwcCodesGroupRetroTier.all.order(discount_tier: :asc).pluck(:discount_tier).uniq
    @accounts = Account.where(representative_id: params[:representative_id]).paginate(page: params[:page], per_page: 50)
    @accounts = @accounts.status(params[:status]).paginate(page: params[:page], per_page: 50) if params[:status].present?
    @accounts = @accounts.group_rating_tier(params[:group_rating_tier]).paginate(page: params[:page], per_page: 50) if params[:group_rating_tier].present?
    @accounts = @accounts.group_retro_tier(params[:group_retro_tier]).paginate(page: params[:page], per_page: 50) if params[:group_retro_tier].present?


    respond_to do |format|
      format.html
      format.js
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
      redirect_to edit_quote_path(@quote), notice: "Quote was successfully saved."
    else
      flash.now[:alert] = "Error saving account. Please try again."
      render :edit
    end
  end

  def destroy
    @quote = Quote.find(params[:id])
    @quote.remove_quote_generated!
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
        uploader = QuoteUploader.new
        tmpfile = Tempfile.new(["#{ @account.policy_number_entered }_quote_#{ @quote.id }", '.pdf'])
        quote = File.basename(tmpfile)
        quote_path = "https://console.aws.amazon.com/s3/buckets/grouprating/uploads/#{quote}"
        tmpfile.binmode
        tmpfile.write (pdf.render)
        uploader.store! tmpfile
        # av = ActionView::Base.new()
        # av.view_paths = ActionController::Base.view_paths

        #
        # @quote.update_attributes(quote_generated: quote_path)
        # tmpfile.close
        # tmpfile.unlink
        send_data pdf.render, filename: "#{ @account.policy_number_entered }_quote_#{ @quote.id }.pdf",
                              type: "application/pdf",
                              disposition: "inline"
        # pdf.render_file "app/reports/#{ @account.policy_number_entered }_quote_#{ @quote.id }.pdf"
      end
    end
    # redirect_to edit_quote_path(@quote), notice: "Quote Generated"
  end
  #
  # def run_quote_process
  #   @representative = Representative.find(params[:representative_id])
  #   # GenerateQuoteProcess.perform_async(@representative.accountes.ids, current_user.id)
  #   redirect_to quotes_path, notice: "Quoting process has initiated. You will receive an email when the process is completed."
  # end

  private

  def quote_params
    params.require(:quote).permit(:account_id, :program_type, :fees, :amount, :group_code, :quote_tier, :invoice_number, :quote, :quote_generated, :quote_date, :quote_sent_date, :effective_start_date, :effective_end_date, :status, :ac2_signed_on, :ac26_signed_on, :u153_signed_on, :contract_signed_on, :questionnaire_signed_on, :questionnaire_question_1, :questionnaire_question_2, :questionnaire_question_3, :questionnaire_question_4, :questionnaire_question_5)
  end

end
