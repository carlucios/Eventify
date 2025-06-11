# frozen_string_literal: true

# Subscribes current logged user to notifications_channel
class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end
end
