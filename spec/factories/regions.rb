FactoryBot.define do
  factory :region do
    sequence(:name) { |n| "Region #{n}" }
  end
end



#let (:region) {FactoryBot.build_stubbed(:region)}
#let (:region) {FactoryBot.build_stubbed(:region, name: 'asdsad')}
#let (:region) {FactoryBot.create(:region)}  builds it in data base, required for scopes
#nested factories one produce open ticket, one closed
