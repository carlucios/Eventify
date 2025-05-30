class EventRepository
  def self.find_upcoming_nearby(address:, radius_km: 20)
    Event.where('address ILIKE ?', "%#{address}%") # Exemplo básico, trocar por geolocalização real
         .where('start_time > ?', Time.current)
  end
end
