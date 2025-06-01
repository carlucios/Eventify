# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :allow_json_only

  def index
    notifications = NotificationsMemoryStore.for_user(current_user.id)
    notifications = notifications.sort_by { |n| n[:created_at] }.reverse

    unread_count = notifications.count do |n|
      n.is_a?(Hash) ? !n[:read] : false
    end

    respond_to do |format|
      format.json do
        html = render_to_string(partial: 'notifications/list', locals: { notifications: notifications },
                                formats: [:html])
        render json: { html: html,
                       unread_count: unread_count }
      end
    end
  end

  def mark_all_as_read
    NotificationsMemoryStore.mark_all_as_read_for_user(current_user.id)
    head :no_content
  end

  private

  def allow_json_only
    return if request.format.json?

    redirect_to root_path and return
  end
end
