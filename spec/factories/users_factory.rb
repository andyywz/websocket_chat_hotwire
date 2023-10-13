FactoryBot.define do
  factory :user, aliases: [:organizer] do
    sequence(:email) { |n| "person#{n}@example.com" }
    sequence(:username) { |n| "person#{n}" }
    password { "password" }

    trait :test do
      username { "test" }
      email { "test@test.com" }
    end
  end
end
