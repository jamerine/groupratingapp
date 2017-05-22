class ErrorMailer < ActionMailer::Base
 default :from => "jason@dittoh.com"

  def notify_about_sidekiq_exception(exception, context_hash)
     @exception = exception
     @context_hash = context_hash
     mail(:to => 'jason@dittoh.com', :subject => "Sidekiq Retry")
  end

end
