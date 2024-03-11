# == Schema Information
#
# Table name: dance_events
#
#  id          :bigint           not null, primary key
#  city        :string
#  country     :string           not null
#  description :text
#  end_date    :date
#  name        :string           not null
#  start_date  :date
#  tags        :string           default([]), is an Array
#  website     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_dance_events_on_tags     (tags) USING gin
#  index_dance_events_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class DanceEvent < ApplicationRecord
  belongs_to :organizer, class_name: "User", foreign_key: :user_id, inverse_of: :dance_events

  has_many :dance_event_participants, dependent: :destroy
  has_many :participants, through: :dance_event_participants, source: :user

  has_many :dance_event_instructors, dependent: :destroy
  has_many :instructors, through: :dance_event_instructors, source: :user

  validates :country, presence: true

  scope :tagged_one_of, ->(tags) { tags.present? ? where("tags && ARRAY[?]::varchar[]", tags) : all }
  scope :tagged_all_of, ->(tags) { tags.present? ? where("tags @> ARRAY[?]::varchar[]", tags) : all }
  scope :name_like, ->(name) { name.present? ? where("lower(name) like ?", "%#{name}%") : all }

  def self.instructors_name_like(name)
    name.present? ? left_joins(:instructors).where("lower(users.username) like ?", "%#{name}%") : all
  end

  def self.search(str)
    str = str.downcase
    instructors_name_like(str).or(tagged_one_of([str])).or(name_like(str))
  end

  def location
    city ? "#{city}, #{country}" : country
  end

  def instructors_names
    return "TBD" if instructors.blank?

    instructors.pluck("username").join(", ")
  end
end
