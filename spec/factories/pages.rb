FactoryGirl.define do
  factory :page do
    title            'Page test title'
    navigation_title 'Page test navigation title'
    content          'Page test content'
    notes            'Page test notes'

    trait :with_image do
      images { [create(:image)] }
    end
  end
end
