FactoryBot.define do
  factory :user do
    name                  { 'User test name' }
    email                 { 'user@example.com' }
    about                 { 'User test about' }
    password              { 's3cur3p@ssw0rd' }
    password_confirmation { 's3cur3p@ssw0rd' }
    confirmed_at          { Time.now }
    role                  { 'user' }
    humanizer_question_id { '16' }
    humanizer_answer      { '5' }

    after(:build) do |user|
      user.skip_confirmation_notification!
    end

    trait :with_avatar do
      avatar { File.open dummy_file_path('image.jpg') }
    end

    trait :with_curriculum_vitae do
      curriculum_vitae { File.open dummy_file_path('document.txt') }
    end

    trait :editor do
      name  { 'User test editor-name' }
      email { 'editor@example.com' }
      role  { 'editor' }
    end

    trait :admin do
      name  { 'User test admin-name' }
      email { 'admin@example.com' }
      role  { 'admin' }
    end
  end
end
