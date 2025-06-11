# frozen_string_literal: true
# :reek:TooManyStatements
# :reek:InstanceVariableAssumption

# Controller responsible for managing follows created by users.
# Includes standard CRUD actions, additional support for Turbo Frame requests and updates status bar.
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

    webservice_status = Thread.current[:webservice_status]
    if handle_ddos(webservice_status) 
      follows = current_user.follows_as_follower
      follow = follows.find_by(followable: followable)

      if follow
        follow.destroy
      else
        follows.create!(followable: followable)
      end
    end

    respond_to do |format|
      format.html { head :no_content }
    end
  end

  private

  def handle_ddos(webservice_status)
    @ddos_blocked = webservice_status&.dig(:ddos_detected)
    if @ddos_blocked
      StatusChannel.broadcast_to(current_user, {
        time: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
        body: "DDOS BLOCKED: #{webservice_status}"
      })
    end

    !@ddos_blocked
  end

  def follow_repo
    @follow_repo ||= FollowRepository.new
  end
end
