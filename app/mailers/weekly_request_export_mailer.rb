class WeeklyRequestExportMailer < ActionMailer::Base
 default :from => "jason@dittoh.com"

  def weekly_request_export(user, representative, csv_string)
     @representative = representative
     @user = user
     attachments["#{@representative.abbreviated_name}_159_request.txt"] = csv_string
     mail(:to => @user.email, :subject => "#{ @representative.abbreviated_name} 159 Request Export File")
  end

end
