# frozen_string_literal: true

# Represents an event created by a user.
# Events can be followed by users via a polymorphic association.
# When an event is updated, it notifies all its followers by broadcasting a 'content.updated' event.
# This model includes associations for the event's creator (user), followers,
# and the polymorphic 'Follow' records used to track subscriptions.
class Event < ApplicationRecord
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
