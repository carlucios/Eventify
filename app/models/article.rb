class Article < ApplicationRecord
  belongs_to :user

  has_many :follows, as: :followable, dependent: :destroy
  has_many :followers, through: :follows, source: :follower, source_type: "User"

  after_update :notify_followers_of_update

  def notify_followers_of_update
    followers = follows_as_followable.includes(:follower).map(&:follower)
    
    followers.each do |user|
      ActiveSupport::Notifications.instrument("content.updated", user: user, content: self)
    end
  end
  
  has_many :follows_as_followable, as: :followable, class_name: "Follow", dependent: :destroy  
end
