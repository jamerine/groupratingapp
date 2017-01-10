class WeeklyRequestExportMailer < ActionMailer::Base
 default :from => "jason@dittoh.com"

  def weekly_request_export(user, representative, csv_string)
     attachments['report.csv'] = csv_string
     @representative = representative
     @user = user
     mail(:to => @user.email, :subject => "#{ @representative.abbreviated_name} 159 Request Export")
  end

end
