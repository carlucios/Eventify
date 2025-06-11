# frozen_string_literal: true

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
    followable_type = params[:followable_type]
    followable_id = params[:followable_id]
    followable = followable_type.constantize.find(followable_id)

    @ddos_blocked = Thread.current[:webservice_status]&.dig(:ddos_detected)

    if @ddos_blocked
      Rails.logger.info("DDOS BLOCKED: #{Thread.current[:webservice_status]}")
    else
      follow = current_user.follows_as_follower.find_by(followable: followable)

      if follow
        follow.destroy
        Rails.logger.info('Unfollowed successfully')
      else
        current_user.follows_as_follower.create!(followable: followable)
        Rails.logger.info('Followed successulfully')
      end
    end

    respond_to do |format|
      format.html { head :no_content }
    end
  end

  private

  def follow_repo
    @follow_repo ||= FollowRepository.new
  end
end
