require "rails_helper"

describe "Manually adding participants to dance events" do
  before do
    driven_by(:rack_test)
  end

  describe "registration access" do
    it "Dance event organizer can access registration page" do
      organizer = sign_in_default_user
      dance_event = create(:dance_event, organizer:)
      test_users = create_list(:user, 5)

      visit dance_event_path(dance_event)
      click_link "Add participants"
      select test_users[4].email, from: "dance_event_participant[user_id]"
      click_button "Add"

      expect(page).to have_content("User successfully registered")
    end
  end
end
