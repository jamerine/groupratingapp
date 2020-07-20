class QuotesController < ApplicationController

  def new
    @account        = Account.find(params[:account_id])
    @representative = @account.representative
    @quote          = @account.quotes.new
    authorize @quote
    @program_types = Quote.program_types
    @statuses      = Quote.statuses
    @current_date  = Date.current
  end

  def new_group_retro
    @account        = Account.find(params[:account_id])
    @representative = @account.representative
    @quote          = @account.quotes.new
    # authorize @quote
    @program_types = Quote.program_types
    @statuses      = Quote.statuses
    @current_date  = Date.current
  end

  def test_client_packet
    @quote              = Quote.find(params[:id])
    @account            = @quote.account
    @representative     = @account.representative
    @group_rating       = @representative.group_ratings.last
    @program_types      = Quote.program_types
    @type               = @program_types[@quote.program_type]
    @policy_calculation = @account.policy_calculation

    policy_year = @quote.quote_year
    s           = "#{@account.policy_number_entered}-#{policy_year}-#{@quote.program_type}-#{@quote.id}"
    combine_pdf = CombinePDF.new

    intro_pdf        = @representative.matrix? ? MatrixGroupRatingIntro.new(@quote, @account, @policy_calculation, view_context) : ArmGroupRatingIntro.new(@quote, @account, @policy_calculation, view_context)
    intro_pdf_render = intro_pdf.render
    combine_pdf << CombinePDF.parse(intro_pdf_render)

    #   quote_pdf        = GroupRatingQuote.new(@quote, @account, @policy_calculation, view_context)
    #   quote_pdf_render = quote_pdf.render
    #   combine_pdf << CombinePDF.parse(quote_pdf_render)
    #
    #   ac_26_pdf        = Ac26.new(@quote, @account, @policy_calculation, view_context)
    #   ac_26_pdf_render = ac_26_pdf.render
    #   combine_pdf << CombinePDF.parse(ac_26_pdf_render)
    #
    #   contract_pdf        = ArmGroupRatingContract.new(@quote, @account, @policy_calculation, view_context)
    #   contract_pdf_render = contract_pdf.render
    #   combine_pdf << CombinePDF.parse(contract_pdf_render)
    #
    #   questionnaire_pdf        = ArmGroupRatingQuestionnaire.new(@quote, @account, @policy_calculation, view_context)
    #   questionnaire_pdf_render = questionnaire_pdf.render
    #   combine_pdf << CombinePDF.parse(questionnaire_pdf_render)

    send_data combine_pdf.to_pdf,
              filename:    "#{ @account.policy_number_entered }_quote_#{ @quote.id }.pdf",
              type:        "application/pdf",
              disposition: "inline"
  end

  def create
    @account        = Account.find(params[:quote][:account_id])
    @representative = @account.representative
    @group_rating   = @representative.group_ratings.last
    @program_types  = Quote.program_types
    @quote          = Quote.new(quote_params)
    authorize @quote
    @type               = @program_types[params[:quote][:program_type]]
    @policy_calculation = @account.policy_calculation

    if @quote.save
      @quote.update_attributes(quote_date: @quote.created_at)
      policy_year = @quote.quote_year
      s           = "#{@account.policy_number_entered}-#{policy_year}-#{@quote.program_type}-#{@quote.id}"
      @quote.assign_attributes(invoice_number: s)
      ##### ADDED THIS PART #####
      combine_pdf = CombinePDF.new

      if params[:quote][:intro] == "1"
        intro_pdf        = @representative.matrix? ? MatrixGroupRatingIntro.new(@quote, @account, @policy_calculation, view_context) : ArmGroupRatingIntro.new(@quote, @account, @policy_calculation, view_context)
        intro_pdf_render = intro_pdf.render
        combine_pdf << CombinePDF.parse(intro_pdf_render)
      end

      if params[:quote][:quote] == "1"
        quote_pdf        = GroupRatingQuote.new(@quote, @account, @policy_calculation, view_context)
        quote_pdf_render = quote_pdf.render
        combine_pdf << CombinePDF.parse(quote_pdf_render)
      end

      if params[:quote][:ac_26] == "1"
        ac_26_pdf        = Ac26.new(@quote, @account, @policy_calculation, view_context)
        ac_26_pdf_render = ac_26_pdf.render
        combine_pdf << CombinePDF.parse(ac_26_pdf_render)
      end

      if params[:quote][:ac_2] == "1"
        ac_2_pdf        = Ac2.new(@quote, @account, @policy_calculation, view_context)
        ac_2_pdf_render = ac_2_pdf.render
        combine_pdf << CombinePDF.parse(ac_2_pdf_render)
      end

      if params[:quote][:contract] == "1"
        contract_pdf        = ArmGroupRatingContract.new(@quote, @account, @policy_calculation, view_context)
        contract_pdf_render = contract_pdf.render
        combine_pdf << CombinePDF.parse(contract_pdf_render)
      end

      if params[:quote][:questionnaire] == "1"
        questionnaire_pdf        = ArmGroupRatingQuestionnaire.new(@quote, @account, @policy_calculation, view_context)
        questionnaire_pdf_render = questionnaire_pdf.render
        combine_pdf << CombinePDF.parse(questionnaire_pdf_render)
      end

      if params[:quote][:invoice] == "1"
        invoice_pdf        = ArmGroupRatingInvoice.new(@quote, @account, @policy_calculation, view_context)
        invoice_pdf_render = invoice_pdf.render
        combine_pdf << CombinePDF.parse(invoice_pdf_render)
      end

      tmpfile = Tempfile.new(["#{ @account.policy_number_entered }-#{@quote.program_type}-#{ @quote.id }", '.pdf'])
      tmpfile.binmode
      tmpfile.write(combine_pdf.to_pdf)
      @quote.quote_generated = tmpfile
      tmpfile.close
      tmpfile.unlink
      @quote.save!
      ######
      redirect_to edit_quote_path(@quote), notice: "Quote successfully created"
    else
      render :new
    end
  end

  def create_group_retro
    @account        = Account.find(params[:quote][:account_id])
    @representative = @account.representative
    @group_rating   = @representative.group_ratings.last
    @program_types  = Quote.program_types
    @quote          = Quote.new(quote_params)
    authorize @quote
    @type               = @program_types[params[:quote][:program_type]]
    @policy_calculation = @account.policy_calculation
    if @quote.save
      @quote.update_attributes(quote_date: @quote.created_at)
      policy_year = @quote.quote_year
      s           = "#{@account.policy_number_entered}-#{policy_year}-#{@quote.program_type}-#{@quote.id}"
      @quote.assign_attributes(invoice_number: s)
      ##### ADDED THIS PART #####
      combine_pdf = CombinePDF.new

      if params[:quote][:intro] == "1"
        intro_pdf        = ArmGroupRetroIntro.new(@quote, @account, @policy_calculation, view_context)
        intro_pdf_render = intro_pdf.render
        combine_pdf << CombinePDF.parse(intro_pdf_render)
      end

      if params[:quote][:quote] == "1"
        quote_pdf        = GroupRetroQuote.new(@quote, @account, @policy_calculation, view_context)
        quote_pdf_render = quote_pdf.render
        combine_pdf << CombinePDF.parse(quote_pdf_render)
      end

      if params[:quote][:u_153] == "1"
        u_153_pdf        = U153.new(@quote, @account, @policy_calculation, view_context)
        u_153_pdf_render = u_153_pdf.render
        combine_pdf << CombinePDF.parse(u_153_pdf_render)
      end

      if params[:quote][:ac_2] == "1"
        ac_2_pdf        = Ac2.new(@quote, @account, @policy_calculation, view_context)
        ac_2_pdf_render = ac_2_pdf.render
        combine_pdf << CombinePDF.parse(ac_2_pdf_render)
      end

      if params[:quote][:contract] == "1"
        contract_pdf        = ArmGroupRetroContract.new(@quote, @account, @policy_calculation, view_context)
        contract_pdf_render = contract_pdf.render
        combine_pdf << CombinePDF.parse(contract_pdf_render)
      end

      if params[:quote][:assessment] == "1"
        assessment_pdf        = ArmGroupRetroAssessment.new(@quote, @account, @policy_calculation, view_context)
        assessment_pdf_render = assessment_pdf.render
        combine_pdf << CombinePDF.parse(assessment_pdf_render)
      end

      if params[:quote][:invoice] == "1"
        invoice_pdf        = ArmGroupRetroInvoice.new(@quote, @account, @policy_calculation, view_context)
        invoice_pdf_render = invoice_pdf.render
        combine_pdf << CombinePDF.parse(invoice_pdf_render)
      end

      # uploader = QuoteUploader.new
      tmpfile = Tempfile.new(["#{ @account.policy_number_entered }_#{@quote.program_type}_#{ @quote.id }", '.pdf'])
      tmpfile.binmode
      tmpfile.write(combine_pdf.to_pdf)
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
    authorize Quote
    @statuses           = Account.statuses
    @group_rating_tiers = BwcCodesIndustryGroupSavingsRatioCriterium.all.order(market_rate: :asc).pluck(:market_rate).uniq
    @group_retro_tiers  = BwcCodesGroupRetroTier.all.order(discount_tier: :asc).pluck(:discount_tier).uniq
    @accounts           = Account.where(representative_id: params[:representative_id]).paginate(page: params[:page], per_page: 100)
    @accounts           = @accounts.status(params[:status]).paginate(page: params[:page], per_page: 100) if params[:status].present?
    @accounts           = @accounts.group_rating_tier(params[:group_rating_tier]).paginate(page: params[:page], per_page: 100) if params[:group_rating_tier].present?
    @accounts           = @accounts.group_retro_tier(params[:group_retro_tier]).paginate(page: params[:page], per_page: 100) if params[:group_retro_tier].present?
    @accounts           = @accounts.joins(:quotes).where('group_rating_tier > quotes.quote_tier').paginate(page: params[:page], per_page: 100) if params[:qualify_equality_quote] == "Qualify Less Than Quote"
    @accounts           = @accounts.joins(:quotes).where('group_rating_tier < quotes.quote_tier or (group_rating_tier is not null and quotes.quote_tier is null)').paginate(page: params[:page], per_page: 50) if params[:qualify_equality_quote] == "Qualify Better Than Quote"
    @accounts           = @accounts.joins(:quotes).where('group_rating_tier is not null and quotes.quote_tier is null').paginate(page: params[:page], per_page: 100) if params[:qualify_equality_quote] == "Now Qualify"
    @accounts           = @accounts.joins(:quotes).where('group_rating_tier is null and quotes.quote_tier is not null').paginate(page: params[:page], per_page: 100) if params[:qualify_equality_quote] == "Now Do Not Qualify"

    @accounts_all                        = Account.where(representative_id: params[:representative_id])
    @accounts_all                        = @accounts_all.status(params[:status]) if params[:status].present?
    @accounts_all                        = @accounts_all.group_rating_tier(params[:group_rating_tier]) if params[:group_rating_tier].present?
    @accounts_all                        = @accounts_all.group_retro_tier(params[:group_retro_tier]) if params[:group_retro_tier].present?
    @accounts_all                        = @accounts_all.joins(:quotes).where('group_rating_tier > quotes.quote_tier or (group_rating_tier is not null and quotes.quote_tier is null)') if params[:qual_greater_quote] == "Qualify > Quote"
    @accounts_all                        = @accounts_all.joins(:quotes).where('group_rating_tier < quotes.quote_tier') if params[:qual_greater_quote] == "Qualify < Quote"
    @parameters                          = {}
    @parameters[:representative_id]      = params[:representative_id] if params[:representative_id].present?
    @parameters[:status]                 = params[:status] if params[:status].present?
    @parameters[:group_rating_tier]      = params[:group_rating_tier] if params[:group_rating_tier].present?
    @parameters[:group_retro_tier]       = params[:group_retro_tier] if params[:group_retro_tier].present?
    @parameters[:qualify_equality_quote] = params[:qualify_equality_quote] if params[:group_retro_tier].present?

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @quote = Quote.find(params[:id])
    authorize @quote
    @account = @quote.account
  end

  def edit
    @quote = Quote.find(params[:id])
    authorize @quote
    @account       = @quote.account
    @program_types = Quote.program_types
    @statuses      = Quote.statuses
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
    authorize @quote
    @quote.remove_quote_generated!
    @account = @quote.account
    if @quote.destroy
      redirect_to @account, notice: "Quote was successfully deleted."
    else
      redirect_to @quote, notice: "Quote was was not deleted.  Please try again."
    end
  end

  def group_rating_report
    @quote              = Quote.find(params[:quote_id])
    @account            = @quote.account
    @policy_calculation = @account.policy_calculation
    respond_to do |format|
      format.html
      format.pdf do
        pdf        = GroupRatingQuote.new(@quote, @account, @policy_calculation, view_context)
        uploader   = QuoteUploader.new
        tmpfile    = Tempfile.new(["#{ @account.policy_number_entered }_quote_#{ @quote.id }", '.pdf'])
        quote      = File.basename(tmpfile)
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
                  type:                 "application/pdf",
                  disposition:          "inline"
        # pdf.render_file "app/reports/#{ @account.policy_number_entered }_quote_#{ @quote.id }.pdf"
      end
    end
    # redirect_to edit_quote_path(@quote), notice: "Quote `Generate`d"
  end

  #
  # def run_quote_process
  #   @representative = Representative.find(params[:representative_id])
  #   # GenerateQuoteProcess.perform_async(@representative.accountes.ids, current_user.id)
  #   redirect_to quotes_path, notice: "Quoting process has initiated. You will receive an email when the process is completed."
  # end

  def quote_accounts
    if !params[:account_ids].nil?
      redirect_to edit_quote_accounts_quotes_path(account_ids: params[:account_ids], representative_id: params[:representative_id])
    else
      redirect_to quotes_path(representative_id: params[:representative_id]), alert: "Please select accounts to generate quotes!"
    end
  end

  def edit_quote_accounts
    if params[:account_ids].present?
      @parameters        = {}
      @accounts          = Account.where("id in (?)", params[:account_ids])
      @account_ids       = @accounts.pluck(:id)
      @representative    = Representative.find(params[:representative_id])
      @status            = nil
      @group_rating_tier = nil
      @group_retro_tier  = nil
    elsif params[:parameters].present?
      @parameters        = params[:parameters]
      @representative    = Representative.find(@parameters["representative_id"])
      @status            = Account.statuses.key(@parameters["status"].to_i) if @parameters["status"].present?
      @group_rating_tier = @parameters["group_rating_tier"]
      @group_retro_tier  = @parameters["group_retro_tier"]
      @accounts          = Account.where(representative_id: @parameters["representative_id"])
      @accounts          = @accounts.status(@parameters["status"]) if @parameters["status"].present?
      @accounts          = @accounts.group_rating_tier(@parameters["group_rating_tier"]) if @parameters["group_rating_tier"].present?
      @accounts          = @accounts.group_retro_tier(@parameters["group_retro_tier"]) if @parameters["group_retro_tier"].present?
    end

  end

  def generate_account_quotes
    @parameters        = params[:parameters]
    @representative    = Representative.find(params[:quote_checkboxes][:representative_id].to_i)
    @status            = Account.statuses[params[:quote_checkboxes]["status"]] if params[:quote_checkboxes]["status"].present?
    @group_rating_tier = params[:quote_checkboxes]["group_rating_tier"] if params[:quote_checkboxes]["group_rating_tier"].present?
    @group_retro_tier  = params[:quote_checkboxes]["group_retro_tier"] if params[:quote_checkboxes]["group_retro_tier"].present?
    if params["account_ids"].present?
      @account_ids = params["account_ids"]
    else
      @accounts = Account.where(representative_id: @representative.id)
      @accounts = @accounts.status(@status) if @status.present?
      @accounts = @accounts.group_rating_tier(@group_rating_tier) if @group_rating_tier.present?
      @accounts = @accounts.group_retro_tier(@group_retro_tier) if @group_retro_tier.present?

      @account_ids = @accounts.pluck(:id)
    end
    GenerateGroupRatingQuoteProcess.perform_async(@representative.id, current_user.id, @account_ids, params[:quote_checkboxes]["ac_2"], params[:quote_checkboxes]["ac_26"], params[:quote_checkboxes]["contract"], params[:quote_checkboxes]["intro"], params[:quote_checkboxes]["invoice"], params[:quote_checkboxes]["questionnaire"], params[:quote_checkboxes]["quote"])
    redirect_to quotes_path(representative_id: @representative.id), notice: "Quoting packet process has started. Please check your email for a link to a zip file for the collection of the quote pdf packets."
  end

  def delete_all_quotes
    DeleteQuoteProcess.perform_async(params[:representative_id])
    # @representative = Representative.find(params[:representative_id])
    # @representative.accounts.find_each do |account|
    #   account.quotes.each do |quote|
    #     quote.remove_quote_generated!
    #     quote.destroy
    #   end
    # end
    redirect_to quotes_path(representative_id: params[:representative_id]), notice: 'The Quotes are being deleted. Please refresh the page to reflect the deleted quotes.'
  end

  def view_group_rating_quote
    @quote              = Quote.find(params[:quote_id])
    @account            = @quote.account
    @policy_calculation = @account.policy_calculation
    respond_to do |format|
      format.html
      format.pdf do
        combine_pdf = CombinePDF.new

        intro_pdf        = ArmGroupRatingIntro.new(@quote, @account, @policy_calculation, view_context)
        intro_pdf_render = intro_pdf.render
        combine_pdf      = CombinePDF.parse(intro_pdf_render)

        quote_pdf        = GroupRatingQuote.new(@quote, @account, @policy_calculation, view_context)
        quote_pdf_render = quote_pdf.render
        combine_pdf << CombinePDF.parse(quote_pdf_render)

        ac_26_pdf        = Ac26.new(@quote, @account, @policy_calculation, view_context)
        ac_26_pdf_render = ac_26_pdf.render
        combine_pdf << CombinePDF.parse(ac_26_pdf_render)

        ac_2_pdf        = Ac2.new(@quote, @account, @policy_calculation, view_context)
        ac_2_pdf_render = ac_2_pdf.render
        combine_pdf << CombinePDF.parse(ac_2_pdf_render)

        # contract_pdf = ArmContract.new(@quote, @account, @policy_calculation, view_context)
        # contract_pdf_render = contract_pdf.render
        # combine_pdf << CombinePDF.parse(contract_pdf_render)

        # questionnaire_pdf = ArmQuestionnaire.new(@quote, @account, @policy_calculation, view_context)
        # questionnaire_pdf_render = questionnaire_pdf.render
        # combine_pdf << CombinePDF.parse(questionnaire_pdf_render)

        # invoice_pdf = ArmInvoice.new(@quote, @account, @policy_calculation, view_context)
        # invoice_pdf_render = invoice_pdf.render
        # combine_pdf << CombinePDF.parse(invoice_pdf_render)


        send_data combine_pdf.to_pdf, filename: "#{ @account.policy_number_entered }_quote_#{ @quote.id }.pdf",
                  type:                         "application/pdf",
                  disposition:                  "inline"
        # pdf.render_file "app/reports/#{ @account.policy_number_entered }_quote_#{ @quote.id }.pdf"
      end
    end
    # redirect_to edit_quote_path(@quote), notice: "Quote Generated"
  end

  def view_group_retro_quote
    @quote              = Quote.find(params[:quote_id])
    @account            = @quote.account
    @policy_calculation = @account.policy_calculation
    respond_to do |format|
      format.html
      format.pdf do
        combine_pdf = CombinePDF.new

        intro_pdf        = ArmGroupRetroIntro.new(@quote, @account, @policy_calculation, view_context)
        intro_pdf_render = intro_pdf.render
        combine_pdf << CombinePDF.parse(intro_pdf_render)

        quote_pdf        = GroupRetroQuote.new(@quote, @account, @policy_calculation, view_context)
        quote_pdf_render = quote_pdf.render
        combine_pdf << CombinePDF.parse(quote_pdf_render)

        u_153_pdf        = U153.new(@quote, @account, @policy_calculation, view_context)
        u_153_pdf_render = u_153_pdf.render
        combine_pdf << CombinePDF.parse(u_153_pdf_render)

        ac_2_pdf        = Ac2.new(@quote, @account, @policy_calculation, view_context)
        ac_2_pdf_render = ac_2_pdf.render
        combine_pdf << CombinePDF.parse(ac_2_pdf_render)

        contract_pdf        = ArmGroupRetroContract.new(@quote, @account, @policy_calculation, view_context)
        contract_pdf_render = contract_pdf.render
        combine_pdf << CombinePDF.parse(contract_pdf_render)

        assessment_pdf        = ArmGroupRetroAssessment.new(@quote, @account, @policy_calculation, view_context)
        assessment_pdf_render = assessment_pdf.render
        combine_pdf << CombinePDF.parse(assessment_pdf_render)

        invoice_pdf        = ArmGroupRetroInvoice.new(@quote, @account, @policy_calculation, view_context)
        invoice_pdf_render = invoice_pdf.render
        combine_pdf << CombinePDF.parse(invoice_pdf_render)

        send_data combine_pdf.to_pdf, filename: "#{ @account.policy_number_entered }_quote_#{ @quote.id }.pdf",
                  type:                         "application/pdf",
                  disposition:                  "inline"
        # pdf.render_file "app/reports/#{ @account.policy_number_entered }_quote_#{ @quote.id }.pdf"
      end
    end
    # redirect_to edit_quote_path(@quote), notice: "Quote Generated"
  end

  private

  def quote_params
    params.require(:quote).permit(:account_id, :program_type, :fees, :group_code, :quote_tier, :invoice_number, :quote, :quote_generated, :quote_date, :effective_start_date, :effective_end_date, :status, :ac2_signed_on, :ac26_signed_on, :u153_signed_on, :contract_signed_on, :questionnaire_signed_on, :questionnaire_question_1, :questionnaire_question_2, :questionnaire_question_3, :questionnaire_question_4, :questionnaire_question_5, :questionnaire_question_6, :updated_by, :created_by, :paid_date, :experience_period_lower_date, :experience_period_upper_date, :current_payroll_period_lower_date, :current_payroll_period_upper_date, :current_payroll_year, :program_year_lower_date, :program_year_upper_date, :program_year, :quote_year_lower_date, :quote_year_upper_date, :quote_year, :paid_amount, :check_number, :questionnaire_question_6, :updated_by, :created_by, :paid_date)
  end

end
