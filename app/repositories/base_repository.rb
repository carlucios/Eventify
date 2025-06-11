# frozen_string_literal: true

# Provides a generic repository interface for ActiveRecord models.
# Encapsulates basic CRUD operations (create, read, update, delete)
# to promote consistency and reuse across specific model repositories.
# Intended to be inherited by concrete repository classes (e.g., ArticleRepository).
class BaseRepository
  def initialize(model_class)
    @model_class = model_class
  end

  def all
    Rails.cache.fetch(cache_key_for_all, expires_in: 10.minutes) do
      @model_class.all.to_a
    end
  end

  def find(id)
    @model_class.find_by(id: id)
  end

  def create(attrs)
    @model_class.create(attrs)
  end

  def update(id, attrs)
    record = find(id)
    record&.update(attrs)
    record
  end

  def destroy(id)
    record = find(id)
    record&.destroy
    record
  end

  def new(attrs = {})
    @model_class.new(attrs)
  end

  private

  def cache_key_for_all
    timestamp = @model_class.maximum(:updated_at)&.utc&.iso8601(6) || 'no-records'
    "#{@model_class.name.underscore.pluralize}/all-#{timestamp}"
  end
end
