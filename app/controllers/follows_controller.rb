# frozen_string_literal: true

# :reek:TooManyStatements
# :reek:InstanceVariableAssumption
# :reek:UtilityFunction

# Controller responsible for managing follows created by users.
# Includes standard CRUD actions, toggle behavior, and DDOS protection.
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
    success = allowed_request?

    followable = find_followable if success
    success &&= followable.present?

    if success
      toggle_follow(followable)
      update_footer_status
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          dom_id(followable, :follow_status),
          partial: "follows/follow_toggle",
          locals: { followable: followable, follow: current_user.follows_as_follower.find_by(followable: followable) }
        )
      end
      format.html { head :no_content }
    end
  end

  private

  def allowed_request?
    !Thread.current[:webservice_status]&.dig(:ddos_detected)
  end

  def find_followable
    params[:followable_type].safe_constantize&.find_by(id: params[:followable_id])
  end

  def toggle_follow(followable)
    user_id = current_user.id
    follow = follow_repo.find_by_follower_and_followable(user_id, followable)

    if follow
      follow.destroy
    else
      follow_repo.create(follower_id: user_id, followable: followable)
    end
  end

  def update_footer_status
    FooterStatusChannel.broadcast_to(
      current_user, {
        time: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
        message: !allowed_request? ? '🚫 Status: Bloqueado por suspeita de DDOS' : '✅ Status: Sistema operando normalmente'
      }
    )
  end

  def follow_repo
    @follow_repo ||= FollowRepository.new
  end
end
