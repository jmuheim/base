FactoryBot.define do
  factory :image do
    file           { File.open dummy_file_path('image.jpg') }
    identifier     { 'Image test identifier' }
    imageable_type { 'Page' }
  end
end
