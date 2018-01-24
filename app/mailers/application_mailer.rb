class ApplicationMailer < ActionMailer::Base
  default from: -> { email_with_name Rails.application.secrets.mailer_from }
  layout 'mailer'

  private

  def email_with_name(email)
    "#{I18n.t 'app.name'} (#{I18n.t 'app.acronym'}) <#{email}>"
  end
end
