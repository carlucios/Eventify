class NotifyFollowersOfUpcomingEventsJob < ApplicationJob
  queue_as :default

  def perform
    Event.where(start_date: Date.tomorrow).find_each do |event|
      event.follows_as_followable.includes(:follower).each do |follow|
        NotificationProcess.call(user: follow.follower, event: event)
      end
    end
  end
end
