class ApplicationMailer < ActionMailer::Base
  default from: -> { email_with_name Rails.application.secrets.mailer_from }
  layout 'mailer'

  private

  def email_with_name(email)
    "#{AppConfig.instance.app_name} (#{AppConfig.instance.app_abbreviation}) <#{email}>"
  end
end
