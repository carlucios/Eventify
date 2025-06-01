# frozen_string_literal: true

# Job responsible for notifying users about upcoming events
# that they follow directly or that are created by users they follow.
class NotifyFollowersOfUpcomingEventsJob < ApplicationJob
  queue_as :default

  def perform
    Event.where(start_date: Date.tomorrow).find_each do |event|
      ActiveSupport::Notifications.instrument('event.upcoming', event: event)
    end
  end
end
