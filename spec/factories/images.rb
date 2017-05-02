FactoryGirl.define do
  factory :image do
    file { File.open dummy_file_path('image.jpg') }
    identifier 'Image test identifier'
    creator_id 0
  end
end