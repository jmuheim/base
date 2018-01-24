require "rails_helper"

RSpec.describe ApplicationMailer do
  describe '#email_with_name' do
    it 'returns the email with app name' do
      mailer = ApplicationMailer.new

      expect(mailer.send :email_with_name, 'test@example.com').to eq 'Base Project (Base) <test@example.com>'
    end
  end
end
