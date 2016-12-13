class PolicyExportMailer < ActionMailer::Base
 default :from => "jason@dittoh.com"

  def policy_export(email, representative_name, csv_string)
     attachments['report.csv'] = csv_string
      mail(:to => email, :subject => "#{representative_name} Policy Export")
  end

end
