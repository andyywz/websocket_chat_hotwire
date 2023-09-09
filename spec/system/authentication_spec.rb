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

    expect(page).to have_content("You need to sign in or sign up before continuing.")
    expect(page).to have_current_path("/users/sign_in")
  end

  it "redirects users to the sign in page when visiting the edit dance event page" do
    dance_event = create(:dance_event)
    visit "/dance_events/edit/#{dance_event.id}"

    expect(page).to have_content("You need to sign in or sign up before continuing.")
    expect(page).to have_current_path("/users/sign_in")
  end
end
