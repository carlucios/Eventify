class EventRepository < BaseRepository
  def initialize
    super(Event)
  end

  def by_user(user_id)
    Event.where(user_id: user_id)
  end

  def upcoming_nearby(latitude, longitude, radius_km = 10)
    Event
      .where("start_date > ?", Time.current)
      .select do |event|
        distance = Geocoder::Calculations.distance_between(
          [latitude, longitude],
          [event.latitude, event.longitude]
        )
        distance <= radius_km
      end
  end

  def published
    Event.where("start_date <= ? AND end_date >= ?", Time.current, Time.current)
  end
end
