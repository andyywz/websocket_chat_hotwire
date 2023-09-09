require "rails_helper"

describe "Creating Dance Events" do
  before do
    driven_by(:rack_test)
  end

  scenario 'user can create dance event' do
    user = sign_in_default_user

    click_on 'New dance event'
    fill_in 'Name', with: 'ILHC'
    fill_in 'Description', with: 'This is gonna be great!'
    fill_in 'Start date', with: Date.today
    fill_in 'End date', with: Date.tomorrow
    fill_in 'Country', with: 'USA'
    fill_in 'City', with: 'New York'
    fill_in 'Website', with: 'www.website.com'
    click_on 'Create Dance event'

    expect(page).to have_content('Dance event was successfully created')
    expect(page).to have_content('ILHC')
    expect(page).to have_content("Organizer: #{user.username}")
    expect(page).to have_content("Dates: #{Date.today.to_s} to #{Date.tomorrow.to_s}")
    expect(page).to have_content('Location: New York, USA')
    expect(page).to have_content('This is gonna be great!')
  end
end
