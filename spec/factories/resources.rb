FactoryBot.define do
  factory :resource_category do
    sequence(:name) { |n| "Test Resource #{n}" }
    active { true }
  end
end

