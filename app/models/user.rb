class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  
  has_many :access_grants, class_name: 'DoorKeeper::AccessGrant', foreign_key: :resource_owner_id, dependent: :delete_all
  has_many :access_tokens, class_name: 'DoorKeeper::AccessToken', foreign_key: :resource_owner_id, dependent: :delete_all
  
  has_many :dance_events
  
  validates_presence_of :username
end
