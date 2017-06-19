class ContactsController < ApplicationController
  require 'csv'

  def new
    @account = Account.find(params[:account_id])
    @contact = Contact.new
    @contact_types = Contact.contact_types
    @prefixes = Contact.prefixes
  end

  def create
    @account = Account.find(params[:contact][:account_id])
    @contact = @account.contacts.create(contact_params)
    redirect_to @account
  end

  def destroy
    @contact = Contact.find(params[:id])
    @account = Account.find(params[:account_id])
    @accounts_contacts = AccountsContact.find_by(account_id: @account.id, contact_id: @contact.id)
    if @account.contacts.delete(@contact)
      @contact.destroy
      redirect_to @account, notice: "Contact has been removed"
    else
      redirect_to @account, notice: "Error removing contact"
    end
  end

  def index
    @representatives = Representative.all
  end

  def import_contact_process
    begin
      ContactImportProcess.perform_async(params[:file].path)
      redirect_to :back, notice: "Contacts imported."
    rescue
      redirect_to :back, alert: "There was an error importing file.  Please ensure file columns and file type are correct"
    end
  end


  private

  def contact_params
    params.require(:contact).permit(:prefix, :first_name, :middle_initial, :last_name, :suffix, :email_address, :phone_number, :phone_extension, :mobile_phone, :fax_number, :contact_type, :salesforce_id, :title, :address_line_1, :address_line_2, :city, :state, :zip_code, :country)
  end

end
