require "rails_helper"

describe "Managing Dance Events" do
  before do
    driven_by(:rack_test)
    @user = sign_in_default_user
  end

  scenario 'user can view the full list of dance events' do
    test_events = create_list(:dance_event, 6, organizer: @user)
    
    visit root_path

    test_events.each do |ev|      
      expect(page).to have_content(ev.name)
    end
  end
  
  scenario 'user can create dance event' do
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
  end
  
  scenario 'user can view dance event details' do
    test_event = create(:dance_event, 
      name: 'test event', 
      organizer: @user, 
      start_date: Date.today, 
      end_date: Date.tomorrow,
      description: 'this test event will be the best test event', 
      city: 'NY', 
      country: 'USA',
    )

    visit dance_event_path(test_event)
    
    expect(page).to have_content(test_event.name)
    expect(page).to have_content("Organizer: #{test_event.organizer.username}")
    expect(page).to have_content("Dates: #{test_event.start_date} to #{test_event.end_date}")
    expect(page).to have_content("Location: #{test_event.location}")
    expect(page).to have_content(test_event.description)
  end

  scenario 'user can update dance event details' do
    test_event = create(:dance_event, 
      name: 'test event', 
      organizer: @user, 
      start_date: Date.today, 
      end_date: Date.tomorrow,
      description: 'this test event will be the best test event', 
      city: 'NY', 
      country: 'USA',
    )

    visit dance_event_path(test_event)
    click_on 'Edit this dance event'
    fill_in 'Name', with: 'new event name'
    click_on 'Update Dance event'

    expect(page).to have_content('Dance event was successfully updated.')
    expect(page).to have_content('new event name')
  end

  scenario 'user can destroy existing dance events' do
    test_event = create(:dance_event, 
      name: 'test event', 
      organizer: @user, 
      start_date: Date.today, 
      end_date: Date.tomorrow,
      description: 'this test event will be the best test event', 
      city: 'NY', 
      country: 'USA',
    )

    visit dance_event_path(test_event)
    click_on 'Destroy this dance event'
    
    expect(page).to have_content('Dance event was successfully destroyed.')
    expect(page).to_not have_content('test event')
  end
end
