# frozen_string_literal: true

class SendFollowNotificationJob < ApplicationJob
  queue_as :default

  def perform(action, follower:, followable:)
    followable_name = followable.try(:name) || followable.try(:title) || followable.to_s

    case action.to_s
    when 'follow.created'
      NotificationsChannel.broadcast_to(
        follower,
        time: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
        body: "Você começou a seguir \"#{followable_name}\""
      )

      if followable.is_a?(User)
        NotificationsChannel.broadcast_to(
          followable, {
            time: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
            body: "#{follower.name} começou a te seguir"
          }
        )
      end

    when 'follow.destroyed'
      NotificationsChannel.broadcast_to(
        follower, {
          time: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
          body: "Você deixou de seguir \"#{followable_name}\""
        }
      )

      if followable.is_a?(User)
        NotificationsChannel.broadcast_to(
          followable, {
            time: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
            body: "#{follower.name} deixou de te seguir"
          }
        )
      end
    end
  end
end
