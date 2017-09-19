FactoryGirl.define do
  factory :project do
    name        'Project test name'
    description 'Project test description'

    trait :with_customer do
      customer { create :customer }
    end
  end
end
