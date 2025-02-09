FactoryBot.define do
    factory :ticket do
      name { "Test Ticket" }
      phone { "+1-555-555-5555" }
      description { "This is a test ticket description." }
      closed { false }
      region
      resource_category
      organization { nil }
  
      trait :with_organization do
        organization
      end
  
      trait :closed do
        closed { true }
      end
    end
  end