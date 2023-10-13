require "rails_helper"

describe "Managing Dance Events" do
  before do
    driven_by(:rack_test)
  end

  it "user can view the full list of dance events" do
    user = sign_in_default_user
    test_events = create_list(:dance_event, 6, organizer: user)
    visit root_path

    test_events.each { |ev| expect(page).to have_content(ev.name) }
  end

  it "user can create dance event" do
    sign_in_default_user
    click_link "New dance event"
    fill_in "Name", with: "ILHC"
    fill_in "Description", with: "This is gonna be great!"
    fill_in "Start date", with: Time.zone.today
    fill_in "End date", with: Date.tomorrow
    fill_in "Country", with: "USA"
    fill_in "City", with: "New York"
    fill_in "Website", with: "www.website.com"
    click_button "Create Dance event"

    expect(page).to have_content("Dance event was successfully created")
  end

  it "user can view dance event details" do
    user = sign_in_default_user
    test_event = create(
      :dance_event,
      name: "test event",
      organizer: user,
      start_date: Time.zone.today,
      end_date: Date.tomorrow,
      description: "this test event will be the best test event",
      city: "NY",
      country: "USA",
    )

    visit dance_event_path(test_event)

    expect(page).to have_content(test_event.name)
    expect(page).to have_content("Organizer: #{test_event.organizer.username}")
    expect(page).to have_content("Dates: #{test_event.start_date} to #{test_event.end_date}")
    expect(page).to have_content("Location: #{test_event.location}")
    expect(page).to have_content(test_event.description)
  end

  it "user can update dance event details" do
    user = sign_in_default_user
    test_event = create(
      :dance_event,
      name: "test event",
      organizer: user,
      start_date: Time.zone.today,
      end_date: Date.tomorrow,
      description: "this test event will be the best test event",
      city: "NY",
      country: "USA",
    )

    visit dance_event_path(test_event)
    click_link "Edit this dance event"
    fill_in "Name", with: "new event name"
    click_button "Update Dance event"

    expect(page).to have_content("Dance event was successfully updated.")
    expect(page).to have_content("new event name")
  end

  it "user can destroy existing dance events" do
    user = sign_in_default_user
    test_event = create(
      :dance_event,
      name: "test event",
      organizer: user,
      start_date: Time.zone.today,
      end_date: Date.tomorrow,
      description: "this test event will be the best test event",
      city: "NY",
      country: "USA",
    )

    visit dance_event_path(test_event)
    click_button "Destroy this dance event"

    expect(page).to have_content("Dance event was successfully destroyed.")
    expect(page).not_to have_content("test event")
  end

  it "non-organizers cannot access dance event modification buttons" do
    test_event = create(
      :dance_event,
      name: "test event",
      organizer: create(:user, :test),
    )
    sign_in_as(create(:user, email: "test2@test.com", username: "test2", password: "password"))
    visit dance_event_path(test_event)

    expect(page).not_to have_content("Destroy this dance event")
    expect(page).not_to have_content("Edit this dance event")
  end
end
