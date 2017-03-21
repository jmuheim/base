FactoryGirl.define do
  factory :page do
    title            'Page test title'
    content          'Page test content'
    notes            'Page test notes'

    trait :with_image do
      images { [create(:image)] }
    end
  end
end
