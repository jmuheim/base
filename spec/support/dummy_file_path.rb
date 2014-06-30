module DummyFilePathHelper
  def dummy_file_path(file)
    File.expand_path("spec/support/dummy_files/#{file}")
  end
end

RSpec.configure do |config|
  config.include DummyFilePathHelper, type: :feature
end
