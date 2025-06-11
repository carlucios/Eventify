# frozen_string_literal: true

# :reek:TooManyStatements
# :reek:UtilityFunction

# Notify followed/following user about creation/remotion of follow
class SendFollowNotificationJob < ApplicationJob
  queue_as :default

  def perform(action, follower:, followable:)
    followable_name = followable.try(:name) || followable.try(:title) || followable.to_s
    time_now = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    user_followable = followable.is_a?(User)
    follower_name = follower.name

    case action.to_s
    when 'follow.created'
      NotificationsChannel.broadcast_to(
        follower,
        time: time_now,
        body: "Você começou a seguir \"#{followable_name}\""
      )

      if user_followable
        NotificationsChannel.broadcast_to(
          followable, {
            time: time_now,
            body: "#{follower_name} começou a te seguir"
          }
        )
      end

    when 'follow.destroyed'
      NotificationsChannel.broadcast_to(
        follower, {
          time: time_now,
          body: "Você deixou de seguir \"#{followable_name}\""
        }
      )

      if user_followable
        NotificationsChannel.broadcast_to(
          followable, {
            time: time_now,
            body: "#{follower_name} deixou de te seguir"
          }
        )
      end
    end
  end
end
