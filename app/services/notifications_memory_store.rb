# frozen_string_literal: true

class NotificationsMemoryStore
  MAX_NOTIFICATIONS = 5

  def self.add_for_user(user_id, message)
    key = cache_key(user_id)
    current = Rails.cache.read(key) || []

    new_notification = { message: message, read: false, created_at: Time.current }

    updated = (current + [new_notification]).last(MAX_NOTIFICATIONS)
    Rails.cache.write(key, updated)
  end

  def self.for_user(user_id)
    Rails.cache.read(cache_key(user_id)) || []
  end

  def self.clear_for_user(user_id)
    Rails.cache.delete(cache_key(user_id))
  end

  def self.mark_all_as_read_for_user(user_id)
    key = cache_key(user_id)
    notifications = Rails.cache.read(key) || []

    notifications.each do |n|
      n[:read] = true if n.is_a?(Hash)
    end

    Rails.cache.write(key, notifications)
  end

  def self.cache_key(user_id)
    "notifications_#{user_id}"
  end
end
