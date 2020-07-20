class RepresentativesController < ApplicationController
  require 'zip'
  require 'net/http'

  def index
  end

  def show
    @representative = Representative.find(params[:id])
    authorize @representative
    @accounts = @representative.accounts
    @users    = @representative.users
    # respond_to do |format|
    #   format.html
    #   format.csv { send_data @policy_calculations.to_csv, filename: "#{@representative.abbreviated_name}_policies_#{Date.today}.csv" }
    # end
  end

  def users_management
    @representative = Representative.find(params[:representative_id])
    authorize @representative
    @representative_users = @representative.users
    @available_users      = User.where.not(id: @representative_users)
  end

  def export_accounts
    @representative = Representative.find(params[:representative_id])
    authorize @representative
    AccountPolicyExport.perform_async(current_user.id, @representative.id)

    flash[:notice] = "Your Accounts and Policies export is now being generated.  Please checkout your email for your generated file."
    redirect_to @representative
  end

  def export_manual_classes
    @representative = Representative.find(params[:representative_id])
    authorize @representative
    ManualClassExport.perform_async(current_user.id, @representative.id)

    flash[:notice] = "Your Manual Class export is now being generated.  Please checkout your email for your generated file."
    redirect_to @representative

  end

  def export_159_request_weekly
    @representative = Representative.find(params[:representative_id])
    authorize @representative
    if params[:weekly_request] == 'all'
      @weekly_request = nil
    else
      @weekly_request = params[:weekly_request]
    end
    @statuses         = params[:statuses]
    @account_statuses = Account.statuses
    @status_integers  = []
    @statuses.each do |status|
      @status_integers << @account_statuses[status]
    end
    WeeklyRequest.perform_async(current_user.id, @representative.id, @status_integers, @weekly_request)

    flash[:notice] = "Your Weekly 159 request export is now being generated for accounts with statuses of #{@statuses}.  Please checkout your email for your generated file."
    redirect_to @representative

    # respond_to do |format|
    #   format.html
    #   format.csv { send_data @accounts.to_request(@representative.representative_number), filename: "#{@representative.abbreviated_name}_159_request_#{Date.today}.csv" }
    # end
  end

  def filter_export_159_request_weekly
    @representative = Representative.find(params[:representative_id])
    authorize @representative
    @statuses = Account.statuses

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

  def import_account_notes_process
    @representative = Representative.find(params[:representative_id])

    begin
      CSV.foreach(params[:file].path, headers: true, encoding: 'ISO8859-1:utf-8') do |row|
        notes_hash = row.to_hash.transform_keys(&:parameterize).transform_keys(&:to_sym)
        AccountNotesImport.perform_async(notes_hash, @representative.id, current_user.id)
      end
      redirect_to @representative, notice: "Account Notes Imported."
    rescue
      redirect_to @representative, alert: "There was an error importing file.  Please ensure file columns and file type are correct"
    end
  end

  def import_claim_notes_process
    @representative = Representative.find(params[:representative_id])

    begin
      CSV.foreach(params[:file].path, headers: true, encoding: 'ISO8859-1:utf-8') do |row|
        notes_hash = row.to_hash.transform_keys(&:parameterize).transform_keys(&:to_sym)
        ClaimNotesImport.perform_async(notes_hash, @representative.id)
      end
      redirect_to @representative, notice: "Claim Notes Imported."
    rescue
      redirect_to @representative, alert: "There was an error importing file.  Please ensure file columns and file type are correct"
    end
  end

  def import_contact_process
    @representative = Representative.find(params[:representative_id])
    authorize @representative
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
    authorize @representative
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
    authorize @representative
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

  def edit_global_dates
    @representative = Representative.find(params[:representative_id])
    authorize @representative
  end

  def fee_calculations
    @representative = Representative.find(params[:representative_id])
    authorize @representative
    @policy_calculations = PolicyCalculation.where(representative_id: @representative.id)
    flash.now[:alert]    = "All of #{@representative.abbreviated_name} policies are beginning to update."
    @policy_calculations.each do |policy|
      policy.fee_calculation
    end
    flash[:notice] = "All of #{@representative.abbreviated_name} policies group fees are now updated."
    redirect_to representatives_path
  end

  def update
    @representative = Representative.find(params[:id])
    authorize @representative
    @representative.assign_attributes(representative_params)
    if @representative.save
      redirect_to @representative, notice: 'Logo successfully added to Representative'
    else
      redirect_to @representative, alert: 'Error adding logo to Representative'
    end
  end

  def all_quote_process
    @representative = Representative.find(params[:representative_id])
    authorize @representative
    @account_ids = @representative.accounts.pluck(:id)
    GenerateGroupRatingQuoteProcess.perform_async(@representative.id, current_user.id, @account_ids)
    redirect_to quotes_path(representative_id: @representative.id), notice: 'The Group Rating Quoting Process has successfully started.  Please allow a few for this process to complete.'
  end

  def zip_file
    @representative = Representative.find(params[:representative_id])
    authorize @representative
    temp_file = Tempfile.new("zipfile.zip")

    # begin
    #This is the tricky part
    #Initialize the temp file as a zip file
    # Zip::OutputStream.open(temp_file) { |zos| }

    files = ["1041902_quote_759420170405-4-ysyis4.pdf", "1042217_quote_760520170405-4-xeeehp.pdf"]

    folder = "uploads/images"

    zip_stream = Zip::OutputStream.write_buffer do |zip|
      # Loop through the files we want to zip

      files.each do |file_name|

        # Get the file object
        uri      = URI("https://s3.amazonaws.com/grouprating/uploads/quote/#{file_name}")
        file_obj = Net::HTTP.get(uri) # => String

        # Give a name to the file and start a new entry
        zip.put_next_entry(file_name)

        # Write the file data to zip
        # zip.print file_obj.get.body.read
        zip.print file_obj
      end
    end


    # Rewind the IO stream so we can read it
    zip_stream.rewind

    # Create a temp file for the zip
    tempZip = Tempfile.new(['pdf_stream', '.zip'])

    # Write the stringIO data
    tempZip.binmode
    tempZip.write zip_stream.read

    @representative.zip_file = tempZip
    @representative.save!
    # Clean up the tmp file
    zip_data = File.read("#{Rails.root}/public#{@representative.zip_file.url}")
    send_data(zip_data, :type => 'application/zip', :filename => "filename.zip")
    tempZip.close
    tempZip.unlink
    # pdf.render_file "app/reports/#{ @account.policy_number_entered }_quote_#{ @quote.id }.pdf"
    #Add files to the zip file as usual
    # Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
    #     @account = Account.find(3776)
    #     @quote = @account.quotes.where(program_type: 0).last
    #     zip.add(URI.parse(@quote.quote_generated.url))
    #     @representative.zip_file = zip
    #     @representative.save!
    # end

    #Close and delete the temp file
    # temp_file.close
    # temp_file.unlink
    # redirect_to @representative
  end

  def all_account_group_rating
    @representative = Representative.find(params[:representative_id])
    authorize @representative
    RepresentativeAllAccountRating.perform_async(@representative.id)
    redirect_to @representative, notice: "Group Rating is being calculated for all accounts under #{@representative.company_name}.  Please allow a few for this process to complete."
  end

  private

  def representative_params
    params.require(:representative).permit(:logo, :experience_period_lower_date, :experience_period_upper_date, :current_payroll_period_lower_date, :current_payroll_period_upper_date,
                                           :current_payroll_year, :program_year_lower_date, :program_year_upper_date, :program_year, :quote_year_lower_date, :quote_year_upper_date, :quote_year,
                                           :location_address_1, :location_address_2, :location_city, :location_state, :location_zip_code, :mailing_address_1, :mailing_address_2, :mailing_city,
                                           :mailing_state, :mailing_zip_code, :phone_number, :toll_free_number, :fax_number, :email_address, :president_first_name, :president_last_name,
                                           :signature, :president, :footer)
  end

end
