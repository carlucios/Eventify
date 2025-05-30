class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]

  def index
    @events = event_repo.all
  end

  def show
    @follow = current_user.follows_as_follower.find_by(followable: @event)
    @author_follow = current_user.follows_as_follower.find_by(followable: @event.user)
  
    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "events/detail", locals: { event: @event } }
    end
  end  

  def new
    @event = event_repo.new
  end

  def edit
  end

  def create
    @event = event_repo.create(event_params.merge(user_id: current_user.id))

    if @event.persisted?
      redirect_to @event, notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy!
    redirect_to events_path, notice: "Event was successfully destroyed.", status: :see_other
  end

  private
    def event_repo
      @event_repo ||= EventRepository.new
    end

    def set_event
      @event = event_repo.find(params.expect(:id))
    end

    def event_params
      params.require(:event).permit(:title, :description, :start_date, :end_date, :address, :latitude, :longitude)
    end
end
