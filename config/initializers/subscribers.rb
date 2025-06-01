# frozen_string_literal: true

ActiveSupport::Notifications.subscribe(/follow\.(created|destroyed)/) do |event_name, _start, _finish, _id, payload|
  follower = payload[:follower]
  followable = payload[:followable]

  action = event_name.split('.').last
  followable_type = followable.class.name
  followable_name = followable.try(:name) || followable.try(:title) || followable.to_s

  message_to_follower = case action
                        when 'created'
                          "Você começou a seguir \"#{followable_name}\""
                        when 'destroyed'
                          "Você deixou de seguir \"#{followable_name}\""
                        end

  NotificationsMemoryStore.add_for_user(follower.id, message_to_follower)

  if followable.is_a?(User) && action == 'created'
    message_to_followable = "#{follower.name} começou a te seguir"
    NotificationsMemoryStore.add_for_user(followable.id, message_to_followable)
  end
end

ActiveSupport::Notifications.subscribe('event.upcoming') do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  event_obj = event.payload[:event]

  interested_users = (event_obj.followers + event_obj.user.followers).uniq

  interested_users.each do |user|
    message = "O evento \"#{event_obj.title}\" começará em breve."
    NotificationsMemoryStore.add_for_user(user.id, message)
  end
end
