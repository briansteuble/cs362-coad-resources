FactoryBot.define do
  factory :organization do
    sequence(:name) { |n| "Test Organization #{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    phone { "1234567890" }
    status { :submitted }
    primary_name { "John Doe" }
    secondary_name { "Jane Doe" }
    secondary_phone { "0987654321" }
  end
end
