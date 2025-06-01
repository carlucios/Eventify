class NotificationProcess < Solid::Process
  input do
    attribute :user
    attribute :event
    attribute :follower
    attribute :followable
    attribute :action
  end

  def call(attributes)
    Given(attributes)
      .and_then(:determine_notification_target)
      .and_then(:build_notification_message)
      .and_then(:render_notification_html)
      .and_then(:broadcast_notification)
  end

  private

  def determine_notification_target(user:, followable:, **)
    target = user || extract_followable_owner(followable)
    Continue(notification_target: target)
  end

  def build_notification_message(event:, user:, follower:, followable:, action:, **)
    message = if event && user
      "Evento '#{event.title}' vai acontecer amanhã!"
    elsif follower && followable && action
      build_follow_message(follower, followable, action)
    else
      raise ArgumentError, "Dados insuficientes para construir mensagem"
    end

    Continue(notification_message: message)
  end

  def build_follow_message(follower, followable, action)
    case action
    when :created
      "#{follower.name} começou a seguir #{followable_description(followable)}"
    when :destroyed
      "#{follower.name} deixou de seguir #{followable_description(followable)}"
    else
      "Ação desconhecida"
    end
  end

  def followable_description(followable)
    case followable
    when User
      "você"
    when Article, Event
      "seu #{followable.model_name.human.downcase} \"#{followable.title}\""
    else
      "um conteúdo seu"
    end
  end

  def render_notification_html(notification_message:, **)
    html = ApplicationController.renderer.render(
      partial: 'notifications/notification',
      locals: { message: notification_message }
    )

    Continue(notification_html: html)
  end

  def broadcast_notification(notification_target:, notification_html:, **)
    ActionCable.server.broadcast(
      "notifications_#{notification_target.id}",
      { html: notification_html }
    )

    Continue()
  end

  def extract_followable_owner(followable)
    case followable
    when User
      followable
    when Article, Event
      followable.user
    else
      raise ArgumentError, "Unknown followable type"
    end
  end
end
