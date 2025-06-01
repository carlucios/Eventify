class SendFollowNotificationJob < ApplicationJob
  queue_as :default

  def perform(follower_id, followable_type, followable_id, action)
    follower = User.find_by(id: follower_id)
    followable = followable_type.constantize.find_by(id: followable_id)

    return if follower.nil? || followable.nil?

    NotificationProcess.call(
      follower: follower,
      followable: followable,
      action: action.to_sym
    )
  end
end
