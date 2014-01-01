# Commonly used email steps
#
# To add your own steps make a custom_email_steps.rb
# The provided methods are:
#
# last_email_address
# reset_mailer
# open_last_email
# visit_in_email
# unread_emails_for
# mailbox_for
# current_email
# open_email
# read_emails_for
# find_email
#
# General form for email scenarios are:
#   - clear the email queue (done automatically by email_spec)
#   - execute steps that sends an email
#   - check the user received an/no/[0-9] emails
#   - open the email
#   - inspect the email contents
#   - interact with the email (e.g. click links)
#
# The Turnip steps below are setup in this order.

module EmailHelpers
  def current_email_address
    # Replace with your a way to find your current email. e.g @current_user.email
    # last_email_address will return the last email address used by email spec to find an email.
    # Note that last_email_address will be reset after each Scenario.
    last_email_address || 'example@example.com'
  end
end

placeholder :address do
  match /I/ do |address|
    'example@example.com' # TODO: Try to use @visitor or @member!
  end
end

# placeholder :link do
#   match /.*/ do |link|
#     link
#   end
# end

module EmailSteps
  #
  # Reset the e-mail queue within a scenario.
  # This is done automatically before each scenario.
  #

  step 'no emails have been sent' do
    reset_mailer
  end

  #
  # Check how many emails have been sent/received
  #

  step ':address should receive :amount email(s)' do |address, amount|
    unread_emails_for(address).size.should == parse_email_count(amount)
  end

  step ':address should have :amount email(s)' do |address, amount|
    mailbox_for(address).size.should == parse_email_count(amount)
  end

  step ':address should receive :amount email(s) with subject :subject' do |address, amount, subject|
    unread_emails_for(address).select { |m| m.subject =~ Regexp.new(Regexp.escape(subject)) }.size.should == parse_email_count(amount)
  end

  step ':address should receive :amount email(s) with subject \/:subject\/' do |address, amount, subject|
    unread_emails_for(address).select { |m| m.subject =~ Regexp.new(subject) }.size.should == parse_email_count(amount)
  end

  step ':address should receive an email with the following body:' do |address, expected_body|
    open_email(address, with_text: expected_body)
  end

  #
  # Accessing emails
  #

  # Opens the most recently received email
  step ':address open(s) the email' do |address|
    open_email(address)
  end

  step ':address open(s) the email with subject :subject' do |address, subject|
    open_email(address, with_subject: subject)
  end

  step ':address open(s) the email with subject \/:subject\/' do |address, subject|
    open_email(address, with_subject: Regexp.new(subject))
  end

  step ':address open(s) the email with text :text' do |address, text|
    open_email(address, with_text: text)
  end

  step ':address open(s) the email with text \/:text\/' do |address, text|
    open_email(address, with_text: Regexp.new(text))
  end

  #
  # Inspect the Email Contents
  #

  step 'I/they should see :subject in the email subject' do |text|
    current_email.should have_subject(text)
  end

  step 'I/they should see \/:text\/ in the email subject' do |text|
    current_email.should have_subject(Regexp.new(text))
  end

  step 'I/they should see :text in the email body' do |text|
    current_email.default_part_body.to_s.should include(text)
  end

  step 'I/they should see \/:text\/ in the email body' do |text|
    current_email.default_part_body.to_s.should =~ Regexp.new(text)
  end

  step 'I/they should see the email delivered from :text' do |text|
    current_email.should be_delivered_from(text)
  end

  step 'I/they should see :text in the email :name header' do |text, name|
    current_email.should have_header(name, text)
  end

  step 'I/they should see \/:text\/ in the email :name header' do |text, name|
    current_email.should have_header(name, Regexp.new(text))
  end

  step 'I/they should see it is a multi-part email' do
      current_email.should be_multipart
  end

  step 'I/they should see :text in the email html part body' do |text|
      current_email.html_part.body.to_s.should include(text)
  end

  step 'I/they should see :text in the email text part body' do |text|
      current_email.text_part.body.to_s.should include(text)
  end

  #
  # Inspect the Email Attachments
  #

  step 'I/they should see :amount attachment(s) with the email' do |amount|
    current_email_attachments.size.should == parse_email_count(amount)
  end

  step '/^there should be :amount attachment(s) named :filename' do |amount, filename|
    current_email_attachments.select { |a| a.filename == filename }.size.should == parse_email_count(amount)
  end

  step '/^attachment (\d+) should be named :filename' do |index, filename|
    current_email_attachments[(index.to_i - 1)].filename.should == filename
  end

  step '/^there should be :amount attachment(s) of type :content_type' do |amount, content_type|
    current_email_attachments.select { |a| a.content_type.include?(content_type) }.size.should == parse_email_count(amount)
  end

  step '/^attachment (\d+) should be of type :content_type' do |index, content_type|
    current_email_attachments[(index.to_i - 1)].content_type.should include(content_type)
  end

  step '/^all attachments should not be blank' do
    current_email_attachments.each do |attachment|
      attachment.read.size.should_not == 0
    end
  end

  step '/^show me a list of email attachments' do
    EmailSpec::EmailViewer::save_and_open_email_attachments_list(current_email)
  end

  #
  # Interact with Email Contents
  #

  step ':address follow(s) :link in the email' do |address, link|
    visit_in_email(link, address)
  end

  step 'I/they click the first link in the email' do
    click_first_link_in_email
  end

  #
  # Debugging
  # These only work with Rails and OSx ATM since EmailViewer uses RAILS_ROOT and OSx's 'open' command.
  # Patches accepted. ;)
  #

  step 'save and open current email' do
    EmailSpec::EmailViewer::save_and_open_email(current_email)
  end

  step 'save and open all text emails' do
    EmailSpec::EmailViewer::save_and_open_all_text_emails
  end

  step 'save and open all html emails' do
    EmailSpec::EmailViewer::save_and_open_all_html_emails
  end

  step 'save and open all raw emails' do
    EmailSpec::EmailViewer::save_and_open_all_raw_emails
  end
end
