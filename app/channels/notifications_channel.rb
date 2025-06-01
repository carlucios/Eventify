# frozen_string_literal: true

# This channel streams real-time notifications to the logged-in user.
# Notifications may include updates about upcoming events followed by
# the user or by users they follow.
class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications_#{current_user.id}"
  end
end
