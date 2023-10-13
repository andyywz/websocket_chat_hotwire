class DanceEventParticipant < ApplicationRecord
  belongs_to :dance_event
  belongs_to :user

  validates :user, uniqueness: {
    scope: :dance_event, message: I18n.t("dance_event_participants.validations.one_user_per_dance_event")
  }
end
