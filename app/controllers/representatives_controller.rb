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
        contact_hash = row.to_hash # exclude the price field
        ContactImport.perform_async(contact_hash)
      end
      redirect_to @representative, notice: "Contacts imported."
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






end
