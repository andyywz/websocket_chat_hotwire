require "rails_helper"

RSpec.describe DanceEventParticipant do
  it "validates that a user can only participate in a dance event once" do
    user = create(:user, :test)
    dance_event = create(:dance_event, organizer: user)

    dance_event.participants = [user]
    expect { dance_event.participants.push(user) }.to raise_error(ActiveRecord::RecordInvalid)

    # expect(dance_event.errors[:message]).to eq("can only have 1 registration per dance event")
  end
end
