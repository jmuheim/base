module DummyFileHelper
  def dummy_file_path(file)
    File.expand_path("spec/support/dummy_files/#{file}")
  end

  def dummy_file(file)
    File.open(dummy_file_path(file))
  end
end

RSpec.configure do |config|
  config.include DummyFileHelper
end

FactoryGirl::SyntaxRunner.send(:include, DummyFileHelper)
