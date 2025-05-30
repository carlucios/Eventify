# frozen_string_literal: true

module Events
  # Process to notify attendees of an event when it is updated.
  class NotifyUsersProcess < SolidProcess::Base
    input :event_id

    step :load_event
    step :notify_attendees

    def load_event(ctx)
      ctx[:event] = Event.find(ctx[:event_id])
    end

    def notify_attendees(ctx)
      ctx[:event].attendees.each do |user|
        SolidSupport::Notifications.send_notification(
          inbox: user.inbox_url,
          target: ctx[:event].url,
          summary: "Evento atualizado: #{ctx[:event].title}",
          type: RDF::Vocab::AS.Update
        )
      end
    end
  end
end
