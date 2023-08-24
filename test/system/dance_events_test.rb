require "application_system_test_case"

class DanceEventsTest < ApplicationSystemTestCase
  setup do
    @dance_event = dance_events(:one)
  end

  test "visiting the index" do
    visit dance_events_url
    assert_selector "h1", text: "Dance events"
  end

  test "should create dance event" do
    visit dance_events_url
    click_on "New dance event"

    click_on "Create Dance event"

    assert_text "Dance event was successfully created"
    click_on "Back"
  end

  test "should update Dance event" do
    visit dance_event_url(@dance_event)
    click_on "Edit this dance event", match: :first

    click_on "Update Dance event"

    assert_text "Dance event was successfully updated"
    click_on "Back"
  end

  test "should destroy Dance event" do
    visit dance_event_url(@dance_event)
    click_on "Destroy this dance event", match: :first

    assert_text "Dance event was successfully destroyed"
  end
end
