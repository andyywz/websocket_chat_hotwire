require "test_helper"

class DanceEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dance_event = dance_events(:one)
  end

  test "should get index" do
    get dance_events_url
    assert_response :success
  end

  test "should get new" do
    get new_dance_event_url
    assert_response :success
  end

  test "should create dance_event" do
    assert_difference("DanceEvent.count") do
      post dance_events_url, params: { dance_event: {  } }
    end

    assert_redirected_to dance_event_url(DanceEvent.last)
  end

  test "should show dance_event" do
    get dance_event_url(@dance_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_dance_event_url(@dance_event)
    assert_response :success
  end

  test "should update dance_event" do
    patch dance_event_url(@dance_event), params: { dance_event: {  } }
    assert_redirected_to dance_event_url(@dance_event)
  end

  test "should destroy dance_event" do
    assert_difference("DanceEvent.count", -1) do
      delete dance_event_url(@dance_event)
    end

    assert_redirected_to dance_events_url
  end
end
