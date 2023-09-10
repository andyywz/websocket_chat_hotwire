FactoryBot.define do
  factory :user, aliases: [:organizer] do
    sequence(:email) { |n| "person#{n}@example.com" }

    trait :test do
      username { "test" }
      email { "test@test.com" }
      password { "password" }
    end
  end
end
