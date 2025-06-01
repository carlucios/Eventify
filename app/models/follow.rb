# frozen_string_literal: true

class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followable, polymorphic: true

  after_create_commit :notify_follow_created
  after_destroy_commit :notify_follow_removed

  private

  def notify_follow_created
    SendFollowNotificationJob.perform_later('follow.created', follower: follower, followable: followable)
  end

  def notify_follow_removed
    SendFollowNotificationJob.perform_later('follow.destroyed', follower: follower, followable: followable)
  end
end
