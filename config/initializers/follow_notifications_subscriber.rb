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
