require 'spec_helper'
require 'i18n/tasks'

describe 'I18n' do
  before { @i18n = I18n::Tasks::BaseTask.new }

  it "doesn't have any missing keys" do
    count = @i18n.missing_keys.count
    fail "There are #{count} missing i18n keys! Run 'i18n-tasks missing' for more details." if count > 0
  end

  it "doesn't have any unused keys" do
    count = @i18n.unused_keys.count
    fail "There are #{count} unused i18n keys! Run 'i18n-tasks unused' for more details." if count > 0
  end
end