# frozen_string_literal: true

# :reek:UtilityFunction

# Notifies the subscribed user about upcoming event
class NotifyUpcomingEventJob < ApplicationJob
  queue_as :default

  def perform(event)
    interested_users = (event.followers + event.user.followers).uniq

    interested_users.each do |user|
      NotificationsChannel.broadcast_to(
        user, {
          time: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
          body: "O evento \"#{event.title}\" começará em breve."
        }
      )
    end
  end
end
