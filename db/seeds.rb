# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

users = User.create!([
  {
    username: 'test',
    email: 'test@test.com',
    password: 'password'
  },
  {
    username: 'test2',
    email: 'test2@test.com',
    password: 'password'
  },
  {
    username: 'test3',
    email: 'test3@test.com',
    password: 'password'
  }
])

dance_event_values = Array.new(10).map do |_|
  address = Faker::Address.full_address_as_hash(:city, :country)
  start_date = Faker::Date.forward
  end_date = Faker::Date.forward(from: start_date, days: 7)

  {
    name: "#{address[:city]} Lindy Exchange",
    country: address[:country],
    description: Faker::Food.description,
    start_date: start_date,
    end_date: end_date,
    website: Faker::Internet.url,
    organizer: users.sample
  }
end

dance_events = DanceEvent.create!(dance_event_values)
