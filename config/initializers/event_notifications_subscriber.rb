ActiveSupport::Notifications.subscribe('event.upcoming') do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  event_obj = event.payload[:event]

  interested_users = (event_obj.followers + event_obj.user.followers).uniq

  interested_users.each do |user|
    NotificationProcess.call(event: event_obj, user: user)
  end
end
