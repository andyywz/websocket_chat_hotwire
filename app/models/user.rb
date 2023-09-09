class User < ApplicationRecord
  attr_writer :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, authentication_keys: [:login]
  
  has_many :access_grants, class_name: 'DoorKeeper::AccessGrant', foreign_key: :resource_owner_id, dependent: :delete_all
  has_many :access_tokens, class_name: 'DoorKeeper::AccessToken', foreign_key: :resource_owner_id, dependent: :delete_all
  
  has_many :dance_events

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, multiline: true
  validate :validate_username

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  
  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h)
      .where(["lower(username) = :value OR lower(email) = :value", value: login.downcase]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_h).first
    end
  end

  def login
    @login || self.username || self.email
  end
end
