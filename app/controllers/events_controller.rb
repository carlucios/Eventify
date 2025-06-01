# frozen_string_literal: true

# Controller responsible for managing events created by users.
# Includes standard CRUD actions and additional support for Turbo Frame requests.
class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]
  #before_action :allow_turbo_only, except: %i[index]

  def index
    event_repo.all
  end

  def show
    user_follows = current_user.follows_as_follower
    @follow = user_follows.find_by(followable: @event)
    @author_follow = user_follows.find_by(followable: @event.user)
  end

  def new
    @event = event_repo.new
  end

  def edit; end

  def create
    @event = event_repo.create(event_params.merge(user_id: current_user.id))

    if @event.persisted?
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_path, notice: "Evento excluído." }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@event) }
    end
  end

  private

  def event_repo
    @event_repo ||= EventRepository.new
  end

  def set_event
    @event = event_repo.find(params[:id])
  end

  def allow_turbo_only
    return if turbo_frame_request?

    redirect_to root_path and return
  end

  def event_params
    params.require(:event).permit(:title, :description, :start_date, :end_date, :address, :latitude, :longitude)
  end
end
