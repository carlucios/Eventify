# frozen_string_literal: true

# :reek:UtilityFunction

# Provides data access methods specific to the Event model.
# Inherits common CRUD behavior from BaseRepository.
# Includes custom queries for events by user, upcoming nearby events based on geolocation,
# and currently published events based on start and end dates.
class EventRepository < BaseRepository
  def initialize
    super(Event)
  end

  def by_user(user_id)
    Event.where(user_id: user_id)
  end

  def upcoming_nearby(latitude, longitude, radius_km = 10)
    Event
      .where('start_date > ?', Time.now)
      .select do |event|
        distance = Geocoder::Calculations.distance_between(
          [latitude, longitude],
          [event.latitude, event.longitude]
        )
        distance <= radius_km
      end
  end

  def published
    time_now = Time.now
    Event.where('start_date <= ? AND end_date >= ?', time_now, time_now)
  end
end
