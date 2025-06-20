# frozen_string_literal: true

# Represents an application user who can create and follow content such as events and articles.
# A user can follow other users, events, or articles via polymorphic follow associations.
# Implements Devise authentication with JWT support, and supports geolocation based on the user's address.
# Users can have different roles (attendee, promoter, admin) and are responsible for creating events and articles.
class User < ApplicationRecord
  has_many :follows_as_follower, foreign_key: :follower_id, class_name: 'Follow', dependent: :destroy
  has_many :follows_as_followable, as: :followable, class_name: 'Follow', dependent: :destroy
  has_many :following_users, through: :follows_as_follower, source: :followable, source_type: 'User'
  has_many :following_events, through: :follows_as_follower, source: :followable, source_type: 'Event'
  has_many :following_articles, through: :follows_as_follower, source: :followable, source_type: 'Article'

  has_many :events, dependent: :destroy
  has_many :articles, dependent: :destroy

  devise :database_authenticatable,
         :registerable,
         :rememberable,
         :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::JTIMatcher

  validates :name, presence: true

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  before_create :generate_jti

  enum :role, { attendee: 0, promoter: 1, admin: 2 }

  private

  def generate_jti
    self.jti ||= SecureRandom.uuid
  end
end
