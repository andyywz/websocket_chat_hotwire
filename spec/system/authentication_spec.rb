require "rails_helper"

describe "Authentication", type: :system do
  before { driven_by(:rack_test) }

  it "allows users to navigate to the home page" do
    visit root_path
    expect(page).to have_content("Dance Events")
  end

  it "redirects users to the sign in page when visiting the new dance event page" do
    visit new_dance_event_path

    expect(page).to have_content(
      "You need to sign in or sign up before continuing"
    )
    expect(page).to have_current_path(new_user_session_path)
  end

  it "redirects users to the sign in page when visiting the edit dance event page" do
    dance_event = build_stubbed(:dance_event)
    visit edit_dance_event_path(dance_event.id)

    expect(page).to have_content(
      "You need to sign in or sign up before continuing"
    )
    expect(page).to have_current_path(new_user_session_path)
  end

  it "allows new users to register" do
    visit root_path
    click_on "Sign in"
    click_on "Create account"
    fill_in "Email", with: "test@test.com"
    fill_in "Username", with: "test"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_on "Submit"

    expect(page).to have_content("Welcome! You have signed up successfully")
  end

  it "allows users to login with username" do
    user = create(:user, username: "test", password: "password")

    visit root_path
    click_on "Sign in"
    fill_in "Email/Username", with: user.username
    fill_in "Password", with: "password"
    click_on "Submit"

    expect(page).to have_content("Signed in successfully")
  end

  it "allows users to login with email" do
    user =
      create(
        :user,
        username: "test",
        email: "test@test.com",
        password: "password"
      )

    visit root_path
    click_on "Sign in"
    fill_in "Email/Username", with: user.email
    fill_in "Password", with: "password"
    click_on "Submit"

    expect(page).to have_content("Signed in successfully")
  end

  it "displays an error when user enters the wrong credentials" do
    user = create(:user, username: "test", password: "password")

    visit root_path
    click_on "Sign in"
    fill_in "Email/Username", with: "test"
    fill_in "Password", with: "badpassword"
    click_on "Submit"

    expect(page).to have_content("Invalid Login or password")
  end

  it "does not indicate existing email or username" do
    visit root_path
    click_on "Sign in"
    fill_in "Email/Username", with: "randomusername"
    fill_in "Password", with: "password"
    click_on "Submit"

    expect(page).to have_content("Invalid Login or password")
  end
end
