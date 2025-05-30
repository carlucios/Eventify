# frozen_string_literal: true

module Events
  # Process to notify attendees of an event when it is updated.
  class NotifyUsersProcess < SolidProcess::Base
    step :build_notification
    step :broadcast_notification
  
    def build_notification(input, **)
      user = input[:user]
      event = input[:event]
      {
        user_id: user.id,
        message: "Evento '#{event.title}' acontecerá amanhã!",
        timestamp: Time.current
      }
    end
  
    def broadcast_notification(notification, **)
      Turbo::StreamsChannel.broadcast_replace_to(
        "notifications_user_#{notification[:user_id]}",
        target: "notifications",
        partial: "notifications/notification",
        locals: { notification: notification }
      )
    end
  end
end
