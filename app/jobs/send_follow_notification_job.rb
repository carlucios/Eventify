# frozen_string_literal: true

class SendFollowNotificationJob < ApplicationJob
  queue_as :default

  def perform(action, follower:, followable:)
    ActiveSupport::Notifications.instrument(action, follower:, followable:)
  end
end
