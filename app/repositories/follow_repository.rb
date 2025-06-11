# frozen_string_literal: true
# :reek:InstanceVariableAssumption

# Provides data access methods for the Follow model.
# Inherits basic CRUD functionality from BaseRepository.
# Includes custom methods to manage follow relationships between users,
# such as checking if a follow exists, creating a follow, and unfollowing.
class FollowRepository < BaseRepository
  # Struct to hold follower and followed user IDs for follow operations.
  # Provides a query hash for ActiveRecord lookups.
  FollowParams = Struct.new(:follower_id, :followed_id) do
    def to_query_hash
      { follower_id: follower_id, followed_id: followed_id }
    end
  end

  def initialize
    super(Follow)
  end

  def following(user_id)
    model_class.where(follower_id: user_id)
  end

  def followers(user_id)
    model_class.where(followed_id: user_id)
  end

  def follow?(follow_params)
    model_class.exists?(follow_params.to_query_hash)
  end

  def create_follow(follow_params)
    return if follow?(follow_params)

    model_class.create(follow_params.to_query_hash)
  end

  def unfollow(follow_params)
    follow = model_class.find_by(follow_params.to_query_hash)
    follow&.destroy
  end

  private

  def model_class
    @model_class
  end
end
