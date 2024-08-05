require "rails_helper"

xdescribe "Dance event registration process" do
  before do
    driven_by(:rack_test)
  end

  describe "registration access" do
    context "dance event is published" do
      it "" do
      end
    end

    it "Dance event organizer can access registration page" do
      organizer = sign_in_default_user
      dance_event = create(:dance_event, organizer:)

      visit dance_event_path(dance_event)
      click_link "Add participants"

      expect(page).to have_content("Add users to #{dance_event.name}")
    end

    it "Dance event organizer can register users manually" do
      organizer = sign_in_default_user
      dance_event = create(:dance_event, organizer:)
      test_users = create_list(:user, 5)

      visit dance_event_path(dance_event)
      click_link "Add participants"
      select test_users[4].email, from: "dance_event_participant[user_id]"
      click_button "Add"

      expect(page).to have_content("User successfully registered")
    end

    it "Dance event organizer can remove registered participants manually" do
      organizer = sign_in_default_user
      dance_event = create(:dance_event, organizer:)
      test_users = create_list(:user, 3)
      dance_event.participants = test_users

      visit dance_event_path(dance_event)
      within("#user_#{test_users.last.id}") do
        click_button "Unregister"
      end

      expect(page).to have_content("#{test_users.last.email} was successfully unregistered.")
    end

    it "Random users cannot view unregister participant buttons" do
      organizer = create(:user)
      dance_event = create(:dance_event, organizer:)
      test_users = create_list(:user, 3)
      dance_event.participants = test_users
      sign_in_as(test_users[0])

      visit dance_event_path(dance_event)

      within("#user_#{test_users.last.id}") do
        expect(page).to have_no_button("Unregister")
      end
    end

    it "Dance event organizer can view dance event participants" do
      organizer = sign_in_default_user
      dance_event = create(:dance_event, organizer:)
      test_users = create_list(:user, 5)
      dance_event.participants = test_users[0..2]

      visit dance_event_path(dance_event)

      test_users[0..2].each do |user|
        expect(page).to have_content(user.username)
      end

      test_users[3..].each do |user|
        expect(page).to have_no_content(user.username)
      end
    end

    it "Logged in users can view dance event participants" do
      organizer = create(:user)
      dance_event = create(:dance_event, organizer:)
      test_users = create_list(:user, 3)
      dance_event.participants = test_users
      sign_in_as(test_users[0])

      visit dance_event_path(dance_event)

      test_users.each do |user|
        expect(page).to have_content(user.username)
      end
    end
  end
end
