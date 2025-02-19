FactoryBot.define do
  # Define a separate sequence for closed ticket names.
  sequence :closed_ticket_name do |n|
    "Closed Ticket Name #{n}"
  end

  factory :ticket do
    sequence(:name) { |n| "Ticket Name #{n}" }
    phone { "+1-555-555-5555" }
    description { "This is a test ticket description." }
    closed { false }
    association :region
    association :resource_category
    organization { nil }

    trait :with_organization do
      organization
    end

    trait :closed do
      closed { true }
      # Override the name with a unique closed ticket name using a separate sequence.
      name { generate(:closed_ticket_name) }
    end
  end
end
