class ContactsController < ApplicationController
  require 'csv'

  def new
    @account = Account.find(params[:account_id])
    @contact = Contact.new
    @contact_types = ContactType.all
    @prefixes = Contact.prefixes
  end

  def create
    account_id = params[:contact][:account_id]
    @account = Account.find(account_id)
    @contact = Contact.create(contact_params)
    accounts_contact = AccountsContact.create(account_id: @account.id, contact_id: @contact.id)
    if params[:contact_type_ids].present?
      contact_type_ids = params[:contact_type_ids].reject(&:empty?)
      contact_type_ids.each do |id|
        AccountsContactsContactType.create(accounts_contact_id: accounts_contact.id, contact_type_id: id)
      end
    end
    redirect_to @account, notice: "Contact has been added"
  end

  def destroy
    @contact = Contact.find(params[:id])
    @account = Account.find(params[:account_id])
    @accounts_contact = AccountsContact.find_by(account_id: @account.id, contact_id: @contact.id)
    @accounts_contact.accounts_contacts_contact_types.destroy_all
    if @accounts_contact.delete
      redirect_to @account, notice: "Contact has been removed"
    else
      redirect_to @account, alert: "Error removing contact"
    end
  end

  def edit
    @contact = Contact.find(params[:id])
    @account = Account.find(params[:account_id])
    @accounts_contact = AccountsContact.find_by(account_id: @account.id, contact_id: @contact.id)
    @contact_types = ContactType.all
    @selected_contact_types = @accounts_contact.contact_types
    @prefixes = Contact.prefixes
  end

  def update
    account_id = params[:contact][:account_id]
    @account = Account.find(account_id)
    @contact = Contact.find(params[:contact][:id])
    @contact.update_attributes(contact_params)
    accounts_contact = AccountsContact.find_by(account_id: @account.id, contact_id: @contact.id)
    if params[:contact_type_ids].present?
      AccountsContactsContactType.where(accounts_contact_id: accounts_contact.id).destroy_all
      contact_type_ids = params[:contact_type_ids].reject(&:empty?)
      contact_type_ids.each do |id|
        AccountsContactsContactType.create(accounts_contact_id: accounts_contact.id, contact_type_id: id)
      end
    end
    redirect_to @account, notice: "Contact has been updated"
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
    params.require(:contact).permit(
      :prefix, :first_name, :middle_initial, :last_name, :suffix, :email_address, :phone_number, :phone_extension, :mobile_phone, :fax_number, :salesforce_id, :title, :address_line_1, :address_line_2, :city, :state, :zip_code, :country
    )
  end

end
