class AccountsController < ApplicationController

  def index
    @statuses = Account.statuses
    @accounts = Account.where(representative_id: @representatives)
    if params[:search].present? && params[:representative_number].present?
      @representative = @representatives.find_by(representative_number: params[:representative_number])
      @accounts = @accounts.where(representative_id: @representative.id).search(params[:search]).paginate(page: params[:page], per_page: 50)
    elsif params[:search_name].present? && params[:representative_number].present?
      @representative = @representatives.find_by(representative_number: params[:representative_number])
      @accounts = @accounts.where(representative_id: @representative.id).search_name(params[:search_name]).paginate(page: params[:page], per_page: 50)
    elsif params[:search].present?
      @accounts = @accounts.search(params[:search]).paginate(page: params[:page], per_page: 50)
    elsif params[:search_name].present?
      @accounts = @accounts.search_name(params[:search_name]).paginate(page: params[:page], per_page: 50)
    elsif params[:representative_number].present?
      @representative = @representatives.find_by(representative_number: params[:representative_number])
      @accounts = @accounts.where(representative_id: @representative.id).paginate(page: params[:page], per_page: 50)
    else
      @accounts = @accounts.all.paginate(page: params[:page], per_page: 50)
    end
    @accounts = @accounts.status(params[:status]) if params["status"].present?

    respond_to do |format|
      format.html
      format.js
    end

  end

  def new
    @account = Account.new
    authorize @account
    @representatives = Representative.all
    @statuses = Account.statuses
  end

  def create
    @account = Account.new(account_params)
    authorize @account
    @representative = Representative.find(@account.representative_id)
    if @account.save
      @policy_calculation = PolicyCalculation.where(policy_number: @account.policy_number_entered).update_or_create(policy_number: @account.policy_number_entered, representative_id: @representative.id, representative_number: @representative.representative_number, account_id: @account.id)
      flash[:notice] = "Account was created successfully"
      redirect_to @account
    else
      flash[:alert] = "There was an error creating account. Please try again."
      render :new
    end
  end


  def edit
    @account = Account.find(params[:id])
    authorize @account
    @representatives = Representative.all
    @representative = Representative.find(@account.representative_id)
    @policy_calculation = PolicyCalculation.find_by(account_id: @account.id)
    @statuses = Account.statuses
    # @mailing_address = {:address_type => "mailing", :address_line_1 => @policy_calculation.mailing_address_line_1, :address_line_2 => @policy_calculation.mailing_address_line_2, :city => @policy_calculation.mailing_city, :state => @policy_calculation.mailing_state, :zip_code => @policy_calculation.mailing_zip_code}
    # @location_address = {:address_type => "location", :address_line_1 => @policy_calculation.location_address_line_1, :address_line_2 => @policy_calculation.location_address_line_2, :city => @policy_calculation.location_city, :state => @policy_calculation.location_state, :zip_code => @policy_calculation.location_zip_code}
    # @locations = []
    # @locations.push(@mailing_address)
    # @locations.push(@location_address)
  end

  def update
    @account = Account.find(params[:id])
    authorize @account
    @statuses = Account.statuses
    @account.assign_attributes(account_params)
    if @account.save
      @policy_calculation = PolicyCalculation.where(policy_number: @account.policy_number_entered).update_or_create(policy_number: @account.policy_number_entered, representative_id: @account.representative.id, representative_number: Representative.find(@account.representative.id).representative_number, account_id: @account.id)
      flash[:notice] = "Account was updated successfully"
      redirect_to @account
    else
      flash.now[:alert] = "Error saving account. Please try again."
      render :edit
    end
  end


  def show
    get_details
  end


  def edit_group_rating
    @account = Account.find(params[:account_id])
    @policy_calculation = @account.policy_calculation
    @group_rating_qualifications = Account.group_rating_qualifications
    @group_rating_qualifications[:auto_run] = "3"
    @group_rating_tiers = BwcCodesIndustryGroupSavingsRatioCriterium.where(industry_group: @account.industry_group).pluck(:market_rate)
  end

  def edit_group_retro
    @account = Account.find(params[:account_id])
    authorize @account
    @policy_calculation = @account.policy_calculation
    @group_retro_qualifications = Account.group_rating_qualifications
    @group_retro_qualifications[:auto_run] = "3"
    @group_retro_tier = BwcCodesGroupRetroTier.find_by(industry_group: @account.industry_group).try(:discount_tier)
    @group_retro_tiers = ["#{@group_retro_tier}"]
  end

  def group_rating_calc
    args = params[:account]
    @account = Account.find(params[:account_id])
    if args[:group_rating_qualification] == "auto_run"
      @account.policy_calculation.calculate_experience
      @account.policy_calculation.calculate_premium
      @account.group_rating
      @account.update_attributes(fee_override: args[:fee_override])
      @account.group_rating(user_override: true)
      flash[:notice] = "Account's automatic group rating calculation was successful."
      @acount
      redirect_to @account
    else
      args[:user_override] = true
      @account.group_rating_calc(args)
      flash[:notice] = "Account's group rating calculation was successful."
      redirect_to @account
    end
  end

  def group_retro_calc
    args = params[:account]
    @account = Account.find(params[:account_id])
    if args[:group_retro_qualification] == "auto_run"
      @account.policy_calculation.calculate_experience
      @account.policy_calculation.calculate_premium
      @account.group_retro
      @account.update_attributes(fee_override: args[:fee_override], user_override: false)
      flash[:notice] = "Account's automatic group retro calculation was successful."
      redirect_to @account
    else
      args[:user_override] = true
      @account.group_retro_calc(args)
      flash[:notice] = "Account's group retro calculation was successful."
      redirect_to @account
    end
  end

  def group_rating_calculation
    @account = Account.find(params[:account_id])
    GroupRatingCalculation.new(@account).calculate

    flash[:notice] = "Account Group Rating Calculation Completed."
    redirect_to @account
  end


  def assign
    @account = Account.find(params[:account_id])
    @affiliate = Affiliate.find(params[:account][:id])
    @accounts_affiliate = AccountsAffiliate.create(affiliate_id: @affiliate.id, account_id: @account.id)
    redirect_to @account
  end

  def assign_address
    @account = Account.find(params[:account_id])
    puts params[:address_type]
    redirect_to @account
  end

  # def group_rating
  #   @account = Account.find(params[:account_id])
  #   @account.group_ratings
  #     flash[:notice] = "Account's group rating calculation was successful."
  #     redirect_to @account
  # end

  # def import_account_process
  #
  #   CSV.foreach(params[:file].path, headers: true) do |row|
  #     hash = row.to_hash # exclude the price field
  #     AccountImport.perform_async(hash)
  #   end
  #
  #   redirect_to root_url, notice: "Accounts imported."
  # end

  def import_account_process
    begin
        AccountImportProcess.perform_async(params[:file].path)
      redirect_to :back, notice: "Accounts imported."
    rescue
      redirect_to :back, alert: "There was an error importing file.  Please ensure file columns and file type are correct"
    end

  end

  def new_risk_report
    @account = Account.find(params[:account_id])
    @group_rating = GroupRating.find(params[:group_rating_id])
    @representative = @account.representative

  end

  def retention
    get_details
  end

  def risk_report
    @account = Account.find(params[:account][:account_id])
    @group_rating = GroupRating.find(params[:account][:group_rating_id])
    @report_params = params[:account]

    respond_to do |format|
      format.html
      format.pdf do

        pdf = RiskReport.new(@account, @account.policy_calculation, @group_rating,  @report_params, view_context)
        # pdf = RiskReport.new(@account, @account.policy_calculation, @group_rating, @glance, @experience_stats, @expected_loss_and_premium, @estimated_current_premium, @program_options, @out_of_experience_claims, @in_experience_claims, @green_year_claims, @group_discount_levels, @coverage_status, @experience_modifier_info, @payroll_history, view_context)

        # uploader = QuoteUploader.new
        # tmpfile = Tempfile.new("#{ @account.policy_number_entered }_quote_#{ @quote.id }.pdf")
        # quote = File.basename(tmpfile)
        # quote_path = "https://console.aws.amazon.com/s3/buckets/grouprating/uploads/#{quote}"
        # tmpfile.binmode
        # tmpfile.write (pdf.render)
        # uploader.store! tmpfile
        #
        # @quote.update_attributes(quote_generated: quote_path)
        # tmpfile.close
        # tmpfile.unlink
        send_data pdf.render, filename: "#{ @account.policy_number_entered }_risk_report.pdf",
                              type: "application/pdf",
                              disposition: "inline"
        # pdf.render_file "app/reports/risk_report_#{@account.id}.pdf"
      end
    end
    # redirect_to @account, notice: "Quote Generated"
  end

  def payroll_test_report
    @account = Account.find(params[:account][:account_id])
    @group_rating = GroupRating.find(params[:account][:group_rating_id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = PayrollTestReport.new(@account, @account.policy_calculation, @group_rating, view_context)

        # uploader = QuoteUploader.new
        # tmpfile = Tempfile.new("#{ @account.policy_number_entered }_quote_#{ @quote.id }.pdf")
        # quote = File.basename(tmpfile)
        # quote_path = "https://console.aws.amazon.com/s3/buckets/grouprating/uploads/#{quote}"
        # tmpfile.binmode
        # tmpfile.write (pdf.render)
        # uploader.store! tmpfile
        #
        # @quote.update_attributes(quote_generated: quote_path)
        # tmpfile.close
        # tmpfile.unlink
        send_data pdf.render, filename: "#{ @account.policy_number_entered }_payroll_test.pdf",
                              type: "application/pdf",
                              disposition: "inline"
        # pdf.render_file "app/reports/risk_report_#{@account.id}.pdf"
      end
    end
    # redirect_to @account, notice: "Quote Generated"
  end

  def group_retro_quote
    @account = Account.find(params[:account_id])
    @group_rating = GroupRating.find(params[:group_rating_id])
    @quote = @account.quotes.where(program_type: 1).last
    respond_to do |format|
      format.html
      format.pdf do
        pdf = ArmGroupRetroAssessment.new(@quote, @account, @account.policy_calculation, view_context)

        # uploader = QuoteUploader.new
        # tmpfile = Tempfile.new("#{ @account.policy_number_entered }_quote_#{ @quote.id }.pdf")
        # quote = File.basename(tmpfile)
        # quote_path = "https://console.aws.amazon.com/s3/buckets/grouprating/uploads/#{quote}"
        # tmpfile.binmode
        # tmpfile.write (pdf.render)
        # uploader.store! tmpfile
        #
        # @quote.update_attributes(quote_generated: quote_path)
        # tmpfile.close
        # tmpfile.unlink
        send_data pdf.render, filename: "#{ @account.policy_number_entered }_risk_report.pdf",
                              type: "application/pdf",
                              disposition: "inline"
        # pdf.render_file "app/reports/risk_report_#{@account.id}.pdf"
      end
    end


  end

  def roc_report
    @account = Account.find(params[:account_id])
    @group_rating = GroupRating.find(params[:group_rating_id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = RocReport.new(@account, @account.policy_calculation, @group_rating, view_context)

        # uploader = QuoteUploader.new
        # tmpfile = Tempfile.new("#{ @account.policy_number_entered }_quote_#{ @quote.id }.pdf")
        # quote = File.basename(tmpfile)
        # quote_path = "https://console.aws.amazon.com/s3/buckets/grouprating/uploads/#{quote}"
        # tmpfile.binmode
        # tmpfile.write (pdf.render)
        # uploader.store! tmpfile
        #
        # @quote.update_attributes(quote_generated: quote_path)
        # tmpfile.close
        # tmpfile.unlink
        send_data pdf.render, filename: "#{ @account.policy_number_entered }_roc_report.pdf",
                              type: "application/pdf",
                              disposition: "inline"

        # pdf.render_file "app/reports/risk_report_#{@account.id}.pdf"
      end
    end

  end


  private

  def get_details
    @account = Account.includes(:group_rating_rejections, :group_rating_exceptions, :policy_calculation, :affiliates, :contacts, :quotes, :account_programs).find(params[:id] || params[:account_id])
    @account_changes = @account.versions.map{|v| [v.created_at, v.changeset]}
    @statuses = Account.statuses
    @representative = Representative.find(@account.representative_id)
    @group_rating = GroupRating.find_by(representative_id: @representative.id)
    @new_payroll_calculation = PayrollCalculation.new
    @group_rating_rejections = @account.group_rating_rejections.where(program_type: 'group_rating')
    @group_retro_rejections = @account.group_rating_rejections.where(program_type: 'group_retro')
    @notes = @account.notes.order(created_at: :desc).first(5)
  end

  def account_params
    params.require(:account).permit(:representative_id, :name, :policy_number_entered, :street_address, :street_address_2, :city, :state, :zip_code, :business_phone_number, :business_email_address, :website_url, :group_rating_qualification, :group_rating_tier, :group_fees, :user_override, :industry_group, :group_dues, :total_costs, :status, :federal_identification_number, :cycle_date, :request_date, :quarterly_request, :weekly_request, :ac3_approval, :fee_override)
  end

end
