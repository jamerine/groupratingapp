class RepresentativesController < ApplicationController

  def index
  end

  def show
    @representative = Representative.find(params[:id])
    @accounts = @representative.accounts
    @users = @representative.users
    # respond_to do |format|
    #   format.html
    #   format.csv { send_data @policy_calculations.to_csv, filename: "#{@representative.abbreviated_name}_policies_#{Date.today}.csv" }
    # end
  end

  def users_management
    @representative = Representative.find(params[:representative_id])
    authorize @representative
    @representative_users = @representative.users
    @available_users = User.where.not(id: @representative_users)
  end

  def export_accounts
    @representative = Representative.find(params[:representative_id])
    AccountPolicyExport.perform_async(current_user.id, @representative.id)

    flash[:notice] = "Your Accounts and Policies export is now being generated.  Please checkout your email for your generated file."
    redirect_to @representative
  end


  def export_manual_classes
    @representative = Representative.find(params[:representative_id])
    ManualClassExport.perform_async(current_user.id, @representative.id)

    flash[:notice] = "Your Manual Class export is now being generated.  Please checkout your email for your generated file."
    redirect_to @representative

  end


  def export_159_request_weekly
    @representative = Representative.find(params[:representative_id])
    WeeklyRequest.perform_async(current_user.id, @representative.id)

    flash[:notice] = "Your Weekly 159 request export is now being generated.  Please checkout your email for your generated file."
    redirect_to @representative

    # respond_to do |format|
    #   format.html
    #   format.csv { send_data @accounts.to_request(@representative.representative_number), filename: "#{@representative.abbreviated_name}_159_request_#{Date.today}.csv" }
    # end
  end


  # def import_account_process
  #   @representative = Representative.find(params[:id])
  #   begin
  #     CSV.foreach(params[:file].path, headers: true) do |row|
  #       hash = row.to_hash # exclude the price field
  #       AccountImport.perform_async(hash)
  #     end
  #     redirect_to root_url, notice: "Accounts imported."
  #   rescue
  #     redirect_to @representative, alert: "There was an error importing file.  Please ensure file columns and file type are correct"
  #   end
  # end

  def import_contact_process
    @representative = Representative.find(params[:representative_id])
    begin
      CSV.foreach(params[:file].path, headers: true) do |row|
        contact_hash = row.to_hash
        ContactImport.perform_async(contact_hash)
      end
      redirect_to @representative, notice: "Contacts imported."
    rescue
      redirect_to @representative, alert: "There was an error importing file.  Please ensure file columns and file type are correct"
    end
  end

  def import_payroll_process
    @representative = Representative.find(params[:representative_id])
    begin
      CSV.foreach(params[:file].path, headers: true) do |row|
        payroll_hash = row.to_hash
        PayrollImport.perform_async(payroll_hash)
      end
      redirect_to @representative, notice: "Payrolls imported."
    rescue
      redirect_to @representative, alert: "There was an error importing file.  Please ensure file columns and file type are correct"
    end
  end

  def import_claim_process
    @representative = Representative.find(params[:representative_id])
    begin
      CSV.foreach(params[:file].path, headers: true) do |row|
        claim_hash = row.to_hash
        ClaimImport.perform_async(claim_hash)
      end
      redirect_to @representative, notice: "Claims imported."
    rescue
      redirect_to @representative, alert: "There was an error importing file.  Please ensure file columns and file type are correct"
    end
  end



  def edit
    @representative = Representative.find(params[:id])
  end

  def fee_calculations
    @representative = Representative.find(params[:representative_id])
    @policy_calculations = PolicyCalculation.where(representative_id: @representative.id )
    flash.now[:alert] = "All of #{@representative.abbreviated_name} policies are beginning to update."
    @policy_calculations.each do |policy|
      policy.fee_calculation
    end
    flash[:notice] = "All of #{@representative.abbreviated_name} policies group fees are now updated."
    redirect_to representatives_path
  end


  def update
    @representative = Representative.find(params[:id])
    @representative.assign_attributes(representative_params)
    if @representative.save
      redirect_to @representative, notice: 'Logo successfully added to Representative'
    else
      redirect_to @representative, alert: 'Error adding logo to Representative'
    end
  end

  def all_quote_process
     @representative = Representative.find(params[:representative_id])
     @account_ids = @representative.accounts.pluck(:id)
     GenerateQuoteProcess.perform_async(@representative.id, current_user, @account_ids)
     redirect_to quotes_path(representative_id: @representative.id), notice: 'The Group Rating Quoting Process has successfully started.  Please allow a few for this process to complete.'
  end



  private

  def representative_params
    params.require(:representative).permit(:logo)
  end

end
