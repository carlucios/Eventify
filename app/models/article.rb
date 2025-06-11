# frozen_string_literal: true

# Represents a written article authored by a user.
# Articles can be followed by users and notify their followers when updated.
# Includes associations for the author (user), followers via a polymorphic 'Follow' model,
# and a callback to notify followers after updates.
class Article < ApplicationRecord
  belongs_to :user

  has_many :follows, as: :followable, dependent: :destroy
  has_many :followers, through: :follows, source: :follower, source_type: 'User'

  after_update :notify_followers_of_update

  def notify_followers_of_update
    followers = follows_as_followable.includes(:follower).map(&:follower)

    followers.each do |user|
      ActiveSupport::Notifications.instrument('content.updated', user: user, content: self)
    end
  end

  has_many :follows_as_followable, as: :followable, class_name: 'Follow', dependent: :destroy
end
