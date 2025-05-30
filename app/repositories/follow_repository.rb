# app/repositories/follow_repository.rb
class FollowRepository < BaseRepository
  def initialize
    super(Follow)
  end

  def following(user_id)
    @model_class.where(follower_id: user_id)
  end

  def followers(user_id)
    @model_class.where(followed_id: user_id)
  end

  def follow?(follower_id, followed_id)
    @model_class.exists?(follower_id: follower_id, followed_id: followed_id)
  end

  def create_follow(follower_id:, followed_id:)
    return if follow?(follower_id, followed_id)
    @model_class.create(follower_id: follower_id, followed_id: followed_id)
  end

  def unfollow(follower_id:, followed_id:)
    follow = @model_class.find_by(follower_id: follower_id, followed_id: followed_id)
    follow&.destroy
  end
end
