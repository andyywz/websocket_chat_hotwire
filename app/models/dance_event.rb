class DanceEvent < ApplicationRecord
  belongs_to :organizer, class_name: "User", foreign_key: :user_id

  validates :country, presence: true

  def location
    city ? "#{city}, #{country}" : country
  end
end
