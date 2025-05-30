# frozen_string_literal: true

# Eventify/app/jobs/send_event_reminder_job.rb
class SendEventReminderJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    event = Event.find(event_id)
    event.attendees.each do |user|
      SolidSupport::Notifications.send_notification(
        inbox: user.inbox_url,
        target: event.url,
        summary: "Lembrete: evento #{event.title} amanhã",
        type: RDF::Vocab::AS.Announce
      )
    end
  end
end
