FactoryBot.define do
  factory :dance_event do
    sequence(:name) { |n| "Event #{n}" }
    country { "USA" }
    published { true }
  end
end
