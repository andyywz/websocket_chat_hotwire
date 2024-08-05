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
class DanceEventParticipant < ApplicationRecord
  belongs_to :dance_event
  belongs_to :user

  validates :user, uniqueness: {
    scope: :dance_event, message: I18n.t("dance_event_participants.validations.uniqueness")
  }
end
