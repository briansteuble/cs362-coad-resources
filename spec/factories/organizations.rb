FactoryBot.define do
  factory :organization do
    name { "Test Organization" }
    email { "test@example.com" }
    phone { "1234567890" }
    status { :submitted }
    primary_name { "John Doe" }
    secondary_name { "Jane Doe" }
    secondary_phone { "0987654321" }
  end
end
