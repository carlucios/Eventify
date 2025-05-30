class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followable, polymorphic: true

  after_create :notify_follow_created

  def notify_follow_created
    ActiveSupport::Notifications.instrument("follow.created", follower: follower, followable: followable)
  end
end
