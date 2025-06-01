ActiveSupport::Notifications.subscribe('follow.created') do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  payload = event.payload

  SendFollowNotificationJob.perform_later(
    payload[:follower].id,
    payload[:followable].class.name,
    payload[:followable].id,
    'created'
  )
end

ActiveSupport::Notifications.subscribe('follow.destroyed') do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  payload = event.payload

  SendFollowNotificationJob.perform_later(
    payload[:follower].id,
    payload[:followable].class.name,
    payload[:followable].id,
    'destroyed'
  )
end

ActiveSupport::Notifications.subscribe('event.upcoming') do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  event_obj = event.payload[:event]

  interested_users = (event_obj.followers + event_obj.user.followers).uniq

  interested_users.each do |user|
    NotificationProcess.call(event: event_obj, user: user)
  end
end
