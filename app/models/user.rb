# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  biography              :text
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  attr_writer :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         authentication_keys: [:login]
  has_many :access_grants, class_name: "DoorKeeper::AccessGrant", foreign_key: :resource_owner_id,
                           dependent: :delete_all
  has_many :access_tokens, class_name: "DoorKeeper::AccessToken", foreign_key: :resource_owner_id,
                           dependent: :delete_all

  has_many :dance_events, dependent: :nullify
  has_many :dance_event_participants, dependent: :destroy
  has_many :attending_dance_events, through: :dance_event_participants, source: :dance_event

  validates :username, format: { with: /^[a-zA-Z0-9_.]*$/, multiline: true }
  validate :validate_username

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  def validate_username
    errors.add(:username, :invalid) if User.exists?(email: username)
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(
        ["lower(username) = :value OR lower(email) = :value", { value: login.downcase }],
      ).first
    elsif conditions.key?(:username) || conditions.key?(:email)
      conditions[:email]&.downcase!
      where(conditions.to_h).first
    end
  end

  def login
    @login || username || email
  end
end
