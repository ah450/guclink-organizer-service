class SubjectTaggerEmailInterceptor
  def self.delivering_email(message)
    message.subject = '[GUCLINK] ' + message.subject
  end

  def self.previewing_email(message)
    SubjectTaggerEmailInterceptor.delivering_email message
  end
end

ActionMailer::Base.register_interceptor SubjectTaggerEmailInterceptor
ActionMailer::Base.register_preview_interceptor SubjectTaggerEmailInterceptor

unless Rails.env.test?
  Rails.application.config.action_mailer.delivery_method = :smtp
  Rails.application.config.action_mailer.smtp_settings = {
    address: ENV['EMAIL_SERVER_ADDRESS'],
    port: ENV['EMAIL_SERVER_PORT']
  }
end
