class ManualClassExportMailer < ActionMailer::Base
 default :from => "jason@dittoh.com"

  def manual_class_export(user, representative, csv_string)
     @representative = representative
     @user = user
     attachments['manual_class_export.csv'] = csv_string
     mail(:to => @user.email, :subject => "#{ @representative.abbreviated_name} Manual Class Export")
  end

end
