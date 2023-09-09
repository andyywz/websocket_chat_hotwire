require "rails_helper"

describe "Authentication", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "allows users to navigate to the home page" do
    visit "/"
    expect(page).to have_content("Dance Events")
  end
  
  it "redirects users to the sign in page when visiting the new dance event page" do
    visit "/dance_events/new"

    expect(page).to have_content("You need to sign in or sign up before continuing")
    expect(page).to have_current_path("/users/sign_in")
  end

  it "redirects users to the sign in page when visiting the edit dance event page" do
    dance_event = FactoryBot.build_stubbed(:dance_event)
    visit "/dance_events/#{dance_event.id}/edit"

    expect(page).to have_content("You need to sign in or sign up before continuing")
    expect(page).to have_current_path("/users/sign_in")
  end

  it "allows new users to register" do
    visit "/"
    click_on "Sign in"
    click_on "Sign up"
    fill_in "Email", with: "test@test.com"
    fill_in "Username", with: "test"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_on "Sign up"

    expect(page).to have_content("Welcome! You have signed up successfully")
  end

  it "allows users to login with username" do
    user = FactoryBot.create(:user, username: 'test', email: 'test@test.com', password: 'password')

    visit "/"
    click_on "Sign in"
    fill_in "Your email/username", with: user.username
    fill_in "Your password", with: 'password'
    click_on "Submit"

    expect(page).to have_content("Signed in successfully")
  end

  it "allows users to login with email" do
    user = FactoryBot.create(:user, username: 'test', email: 'test@test.com', password: 'password')

    visit "/"
    click_on "Sign in"
    fill_in "Your email/username", with: user.email
    fill_in "Your password", with: 'password'
    click_on "Submit"

    expect(page).to have_content("Signed in successfully")
  end

  it "displays an error when user enters the wrong credentials" do
    user = FactoryBot.create(:user, username: 'test', email: 'test@test.com', password: 'password')

    visit "/"
    click_on "Sign in"
    fill_in "Your email/username", with: user.username
    fill_in "Your password", with: 'badpassword'
    click_on "Submit"

    expect(page).to have_content("Invalid Login or password")
  end

  it "does not indicate existing email or username" do
    visit "/"
    click_on "Sign in"
    fill_in "Your email/username", with: 'randomusername'
    fill_in "Your password", with: 'password'
    click_on "Submit"

    expect(page).to have_content("Invalid Login or password")
  end
end
