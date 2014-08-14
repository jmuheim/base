# Configuration for email_spec gem
RSpec.configure do |config|
  if defined?(ActionMailer)
    unless [:test, :activerecord, :cache, :file].include?(ActionMailer::Base.delivery_method)
      ActionMailer::Base.register_observer(EmailSpec::TestObserver)
    end
    ActionMailer::Base.perform_deliveries = true

    config.before(:each) do
      case ActionMailer::Base.delivery_method
        when :test then ActionMailer::Base.deliveries.clear
        when :cache then ActionMailer::Base.clear_cache
      end
    end
  end

  config.after(:each) do
    EmailSpec::EmailViewer.save_and_open_all_raw_emails if ENV['SHOW_EMAILS']
    EmailSpec::EmailViewer.save_and_open_all_html_emails if ENV['SHOW_HTML_EMAILS']
    EmailSpec::EmailViewer.save_and_open_all_text_emails if ENV['SHOW_TEXT_EMAILS']
  end

  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
end