class NotificationProcess
  include SolidProcess::Process

  attr_reader :user, :event, :notification_message

  def initialize(user:, event:)
    @user = user
    @event = event
  end

  def call
    prepare_message
    broadcast_notification
  end

  private

  def prepare_message
    @notification_message = "Evento '#{event.title}' vai acontecer amanhã!"
  end

  def broadcast_notification
    ActionCable.server.broadcast(
      "notifications_#{user.id}",
      Turbo::Streams::TagBuilder.new.broadcast_action(
        action: :append,
        target: "notifications",
        template: ApplicationController.renderer.render(
          partial: "notifications/notification",
          locals: { message: notification_message }
        )
      )
    )
  end
end
