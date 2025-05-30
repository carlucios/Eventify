class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    follow_repo.create(follower_id: current_user.id, followed_id: params[:followed_id])
    redirect_back fallback_location: root_path
  end

  def destroy
    follow = follow_repo.following(current_user.id).find_by(followed_id: params[:followed_id])
    follow&.destroy
    redirect_back fallback_location: root_path
  end
  
  def toggle
    followable = params[:followable_type].constantize.find(params[:followable_id])
    follow = current_user.follows_as_follower.find_by(followable: followable)

    if follow
      follow.destroy
    else
      current_user.follows_as_follower.create!(
        followable: followable,
        followed_id: followable.is_a?(User) ? followable.id : followable.user_id
      )
    end

    redirect_back fallback_location: root_path
  end

  private

  def follow_repo
    @follow_repo ||= FollowRepository.new
  end
end