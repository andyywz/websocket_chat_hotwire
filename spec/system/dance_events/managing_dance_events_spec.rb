require "rails_helper"

describe "Managing Dance Events" do
  before do
    driven_by(:rack_test)
  end

  describe "Dance Events list page" do
    it "user can view all published dance events" do
      sign_in_default_user
      organizer = build(:user)
      test_events = create_list(:dance_event, 6, organizer:, published: true)
      unpublished_event = create(:dance_event, organizer:, published: false)

      visit root_path

      test_events.each { |ev| expect(page).to have_content(ev.name) }
      expect(page).not_to have_content(unpublished_event.name)
    end

    it "user can view all unpublished events that they are organizing" do
      user = sign_in_default_user
      viewable_unpublished_event = create(:dance_event, organizer: user, published: false)
      unpublished_event = create(:dance_event, organizer: build(:user), published: false)

      visit root_path

      expect(page).to have_content(viewable_unpublished_event.name)
      expect(page).not_to have_content(unpublished_event.name)
    end

    it "user can view all unpublished events that they are participating" do
      organizer = build(:user)
      user = sign_in_default_user
      viewable_unpublished_event = create(:dance_event, organizer:, published: false, participants: [user])
      unpublished_event = create(:dance_event, organizer:, published: false)

      visit root_path

      expect(page).to have_content(viewable_unpublished_event.name)
      expect(page).not_to have_content(unpublished_event.name)
    end

    it "user can view all unpublished events that they are instructing" do
      organizer = build(:user)
      user = sign_in_default_user
      viewable_unpublished_event = create(:dance_event, organizer:, published: false, instructors: [user])
      unpublished_event = create(:dance_event, organizer:, published: false)

      visit root_path

      expect(page).to have_content(viewable_unpublished_event.name)
      expect(page).not_to have_content(unpublished_event.name)
    end

    describe "user can filter the list of dance events" do
      it "by tag" do
        user = sign_in_default_user
        other_events = create_list(:dance_event, 6, organizer: user)
        balboa_event = create(:dance_event, organizer: user, tags: ["balboa"])

        visit root_path

        fill_in "Search", with: "balboa"
        click_button "Search"

        expect(page).to have_content(balboa_event.name)
        expect(page).not_to have_content(other_events.first.name)
      end

      it "by name" do
        user = sign_in_default_user
        other_events = create_list(:dance_event, 6, organizer: user)
        balboa_event = create(:dance_event, organizer: user, name: "Super Balboa", tags: ["balboa"])

        visit root_path

        fill_in "Search", with: "Super"
        click_button "Search"

        expect(page).to have_content(balboa_event.name)
        expect(page).not_to have_content(other_events.first.name)
      end

      it "by instructors" do
        user = sign_in_default_user
        mickey = create(:user, username: "mickey")
        kelly = create(:user, username: "kelly")

        other_events = create_list(:dance_event, 6, organizer: user)
        balboa_event = create(:dance_event, organizer: user, name: "Balweek", instructors: [mickey, kelly])
        another_balboa_event = create(:dance_event, organizer: user, name: "Ballove", instructors: [mickey])

        visit root_path

        fill_in "Search", with: "Mickey"
        click_button "Search"

        expect(page).to have_content(balboa_event.name)
        expect(page).to have_content(another_balboa_event.name)
        expect(page).not_to have_content(other_events.first.name)
      end

      it "search is case-insensitive" do
        user = sign_in_default_user
        other_events = create_list(:dance_event, 6, organizer: user)
        balboa_event = create(:dance_event, organizer: user, name: "Lindy and Bal", tags: ["lindy hop", "balboa"])
        another_balboa_event = create(:dance_event, organizer: user, name: "Super BALBOA", tags: ["balboa"])
        yet_another_balboa_event = create(:dance_event, organizer: user, name: "Balapalooza", tags: ["balboa"])

        visit root_path

        fill_in "Search", with: "Balboa"
        click_button "Search"

        expect(page).to have_content(balboa_event.name)
        expect(page).to have_content(another_balboa_event.name)
        expect(page).to have_content(yet_another_balboa_event.name)
        expect(page).not_to have_content(other_events.first.name)
      end
    end
  end

  describe "Dance Event create page" do
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

    it "by default creates an unpublished event" do
      sign_in_default_user
      click_link "New dance event"
      fill_in "Name", with: "ILHC"
      fill_in "Country", with: "USA"

      expect do
        click_button "Create Dance event"
      end.to change(DanceEvent.all, :count).from(0).to(1)
        .and not_change(DanceEvent.published, :count)
    end
  end

  describe "Dance Event show page" do
    context "when page is not published" do
      it "redirects an uninvolved user" do
        sign_in_default_user
        organizer = build(:user)
        test_event = create(
          :dance_event,
          organizer:,
          country: "USA",
          published: false,
        )

        visit dance_event_path(test_event)

        expect(page).to have_content("404 Not Found")
        expect(page).to have_current_path(dance_events_path)
      end

      it "allows the organizer to view the page" do
        organizer = sign_in_default_user
        test_event = create(
          :dance_event,
          organizer:,
          country: "USA",
          published: false,
        )

        visit dance_event_path(test_event)

        expect(page).to have_current_path(dance_event_path(test_event))
      end

      it "allows participants to view the page" do
        user = sign_in_default_user
        test_event = create(
          :dance_event,
          organizer: build(:user),
          country: "USA",
          published: false,
          participants: [user],
        )

        visit dance_event_path(test_event)

        expect(page).to have_current_path(dance_event_path(test_event))
      end

      it "allows instructors to view the page" do
        user = sign_in_default_user
        test_event = create(
          :dance_event,
          organizer: build(:user),
          country: "USA",
          published: false,
          instructors: [user],
        )

        visit dance_event_path(test_event)

        expect(page).to have_current_path(dance_event_path(test_event))
      end
    end

    it "users can view dance event details" do
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

    it "users can view dance event instructors" do
      user = sign_in_default_user
      mickey = create(:user, username: "mickey")
      kelly = create(:user, username: "kelly")
      test_event = create(
        :dance_event,
        name: "test event",
        organizer: user,
        start_date: Time.zone.today,
        end_date: Date.tomorrow,
        description: "this test event will be the best test event",
        city: "NY",
        country: "USA",
        instructors: [mickey, kelly],
      )

      visit dance_event_path(test_event)

      expect(page).to have_content(test_event.name)
      expect(page).to have_content("Instructors: #{mickey.username}, #{kelly.username}")
    end

    it "organizer can destroy existing dance events" do
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

    it "non-organizers cannot see dance event modification buttons" do
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

  describe "Dance Event edit page" do
    it "non-organizer are redirected to the show page when attempting to force browse" do
      sign_in_default_user
      organizer = build(:user)
      test_event = create(
        :dance_event,
        name: "test event",
        organizer:,
        start_date: Time.zone.today,
        end_date: Date.tomorrow,
        description: "this test event will be the best test event",
        city: "NY",
        country: "USA",
        published: false,
      )

      visit edit_dance_event_path(test_event)

      expect(page).to have_content("401 Unauthorized")
      expect(page).to have_current_path(dance_events_path)
    end

    it "organizer can update dance event details" do
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
  end
end
