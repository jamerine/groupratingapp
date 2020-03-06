class PolicyExportMailer < ApplicationMailer
  def policy_export(user, representative, csv_string)
    attachments['account_policy_export.csv'] = csv_string
    @representative                          = representative
    @user                                    = user
    mail(:to => @user.email, :subject => "#{ @representative.abbreviated_name} Policy Export")
  end
end
