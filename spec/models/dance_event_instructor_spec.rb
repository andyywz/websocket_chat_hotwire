# == Schema Information
#
# Table name: dance_event_instructors
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  dance_event_id :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_dance_event_instructors_on_dance_event_id  (dance_event_id)
#  index_dance_event_instructors_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (dance_event_id => dance_events.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe DanceEventInstructor do
  it "validates that a user can only instruct at a dance event once" do
    user = create(:user, :test)
    dance_event = create(:dance_event, organizer: user)

    dance_event.instructors = [user]
    expect do
      dance_event.instructors.push(user)
    end.to raise_error("Validation failed: User is already an instructor at this dance event")
  end
end
