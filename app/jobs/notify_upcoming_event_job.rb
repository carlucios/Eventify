# frozen_string_literal: true

class NotifyUpcomingEventJob < ApplicationJob
  queue_as :default

  def perform(event)
    interested_users = (event.followers + event.user.followers).uniq

    interested_users.each do |user|
      NotificationsChannel.broadcast_to(
        user, {
          title: "Evento em breve",
          body: "O evento \"#{event.title}\" começará em breve."
        }
      )
    end
  end
end
