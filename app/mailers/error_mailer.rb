class ErrorMailer < ApplicationMailer
 default :from => "info@switchboxinc.com"

  def notify_about_sidekiq_exception(exception, context_hash)
     @exception = exception
     @context_hash = context_hash
     mail(:to => 'amoyer@switchboxinc.com', :subject => "Sidekiq Retry")
  end

end
