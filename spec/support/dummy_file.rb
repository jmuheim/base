module DummyFileHelper
  def dummy_file_path(file)
    File.expand_path("spec/support/dummy_files/#{file}")
  end
end

RSpec.configure do |config|
  config.include DummyFileHelper
end

FactoryGirl::SyntaxRunner.send(:include, DummyFileHelper)
