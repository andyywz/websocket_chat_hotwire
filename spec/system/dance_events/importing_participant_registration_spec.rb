require "rails_helper"

describe "Importing participants to dance events" do
  before do
    driven_by(:rack_test)
  end

  context "when no file is chosen" do
    it "displays a notice" do
      organizer = sign_in_default_user
      dance_event = create(:dance_event, organizer:)

      visit dance_event_path(dance_event)
      click_link "Import participants"

      click_button "Import"

      expect(page).to have_content("No file added")
    end
  end

  context "when the file is not a csv" do
    it "displays a notice" do
      organizer = sign_in_default_user
      dance_event = create(:dance_event, organizer:)

      visit dance_event_path(dance_event)
      click_link "Import participants"

      attach_file "file", file_fixture("system/upload_non_csv.txt")
      click_button "Import"

      expect(page).to have_content("Only CSV files allowed")
    end
  end

  context "when csv contain users that are registered" do
    it "imports adds those users as participants to the dance event" do
      organizer = sign_in_default_user
      test_users = [
        create(:user, email: "test1@test.com", username: "test1"),
        create(:user, email: "test2@test.com", username: "test2"),
        create(:user, email: "test3@test.com", username: "test3"),
      ]
      dance_event = create(:dance_event, organizer:)

      visit dance_event_path(dance_event)
      click_link "Import participants"

      attach_file "file", file_fixture("system/upload_existing_users.csv")
      click_button "Import"

      expect(page).to have_content("Users successfully registered: 3, Users already registered: 0, Users not found: []")
      expect(page).to have_content("test1")
      expect(page).to have_content("test2")
      expect(page).to have_content("test3")
    end

    it "only imports users that are not already participants at the dance event" do
      organizer = sign_in_default_user
      test_users = [
        create(:user, email: "test1@test.com", username: "test1"),
        create(:user, email: "test2@test.com", username: "test2"),
        create(:user, email: "test3@test.com", username: "test3"),
      ]
      dance_event = create(:dance_event, organizer:, participants: test_users[0..1])

      visit dance_event_path(dance_event)
      click_link "Import participants"

      attach_file "file", file_fixture("system/upload_existing_users.csv")
      click_button "Import"

      expect(page).to have_content("Users successfully registered: 1, Users already registered: 2, Users not found: []")
      expect(page).to have_content("test1")
      expect(page).to have_content("test2")
      expect(page).to have_content("test3")
    end
  end

  context "when csv contains users that are not registered" do
    it "imports the existing users and returns a list of unregistered users" do
      organizer = sign_in_default_user
      dance_event = create(:dance_event, organizer:)
      test_users = [
        create(:user, email: "test1@test.com", username: "test1"),
        create(:user, email: "test2@test.com", username: "test2"),
      ]

      visit dance_event_path(dance_event)
      click_link "Import participants"

      attach_file "file", file_fixture("system/upload_existing_users.csv")
      click_button "Import"

      expect(page).to have_content(
        "Users successfully registered: 2, Users already registered: 0, Users not found: [\"test3@test.com\"]",
      )
      expect(page).to have_content("test1")
      expect(page).to have_content("test2")
    end
  end
end
