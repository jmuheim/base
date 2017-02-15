FactoryGirl.define do
  factory :user do
    # Ffaker calls need to be in block?! See https://github.com/EmmanuelOga/ffaker/issues/121
    name                  'User test name'
    email                 'test@email.com'
    about                 'User test about'
    password              's3cur3p@ssw0rd'
    password_confirmation 's3cur3p@ssw0rd'
    confirmed_at          Time.now

    after(:build) do |user|
      user.skip_confirmation_notification!
    end

    trait :donald do
      name 'donald'
      email 'donald@example.com'
    end

    trait :with_avatar do
      avatar { File.open dummy_file_path('image.jpg') }
    end

    trait :with_curriculum_vitae do
      curriculum_vitae { File.open dummy_file_path('document.txt') }
    end

    factory :admin do
      after(:create) do |user|
        user.roles << create(:role, name: 'admin')
      end

      trait :scrooge do
        name  'admin'
        email 'admin@example.com'
      end
    end
  end
end
