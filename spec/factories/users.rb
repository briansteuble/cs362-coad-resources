FactoryBot.define do
    factory :user do
      email { "example@gmail.com" }
      password { "password123" }
      password_confirmation { "password123" }
      role { :organization }
  
      trait :admin do
        role { :admin }
      end
  
      trait :with_organization do
        association :organization
      end
    end
  end