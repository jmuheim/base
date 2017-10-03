FactoryGirl.define do
  factory :timetrack do
    name        'Timetrack test name'
    description 'Timetrack test description'
    work_time   1.50
    bill_time   1.20
  end

  trait :with_project do
    project { create :project }
  end

end
