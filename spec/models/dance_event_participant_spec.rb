# == Schema Information
#
# Table name: dance_event_participants
#
#  id             :bigint           not null, primary key
#  status         :string           default("registered")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  dance_event_id :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_dance_event_participants_on_dance_event_id              (dance_event_id)
#  index_dance_event_participants_on_dance_event_id_and_user_id  (dance_event_id,user_id) UNIQUE
#  index_dance_event_participants_on_status                      (status)
#  index_dance_event_participants_on_user_id                     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (dance_event_id => dance_events.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe DanceEventParticipant do
  it "validates that a user can only participate in a dance event once" do
    user = create(:user, :test)
    dance_event = create(:dance_event, organizer: user)

    dance_event.participants = [user]
    expect do
      dance_event.participants.push(user)
    end.to raise_error("Validation failed: User is already registered to participate in this dance event")
  end
end
