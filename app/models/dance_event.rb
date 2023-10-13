class DanceEvent < ApplicationRecord
  belongs_to :organizer, class_name: "User", foreign_key: :user_id, inverse_of: :dance_events

  has_many :dance_event_participants, dependent: :destroy
  has_many :participants, through: :dance_event_participants, source: :user

  validates :country, presence: true
  def location
    city ? "#{city}, #{country}" : country
  end
end
