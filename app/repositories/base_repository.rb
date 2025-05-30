class BaseRepository
  def initialize(model_class)
    @model_class = model_class
  end

  def all
    @model_class.all
  end

  def find(id)
    @model_class.find_by(id: id)
  end

  def create(attrs)
    @model_class.create(attrs)
  end

  def update(id, attrs)
    record = find(id)
    record.update(attrs) if record
    record
  end

  def destroy(id)
    record = find(id)
    record.destroy if record
    record
  end
end
