class QuotePdfExportMailer < ActionMailer::Base
 default :from => "jason@dittoh.com"

  def quote_pdf_export(representative_id, user_id, account_ids)
     @representative = Representative.find(representative_id)
     @user = User.find(user_id)
     @account_ids = account_ids
     @num_accounts = @account_ids.length
     @zip_file_url = @representative.zip_file.url
     mail(:to => @user.email, :subject => "#{ @representative.abbreviated_name} Quote Zip File")
  end

end
