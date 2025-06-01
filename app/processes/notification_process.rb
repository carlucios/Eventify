# frozen_string_literal: true

class NotificationProcess < Solid::Process
  input do
    attribute :event, default: nil
    attribute :follower, default: nil
    attribute :followable, default: nil
    attribute :action, default: nil
    attribute :user, default: nil
  end

  def call(attributes)
    Given(attributes)
      .and_then(:determine_targets)
      .and_then(:build_messages)
      .and_then(:render_htmls)
      .and_then(:broadcast_all)
  end

  private

  def determine_targets(event:, follower:, followable:, action:, user:, **)
    if event && user
      Continue(targets: [{ user: user, type: :upcoming, event: event }])
    elsif follower && followable && action
      followable_owner = extract_followable_owner(followable)

      Continue(targets: [
                 { user: followable_owner, type: :owner, follower: follower, followable: followable, action: action },
                 { user: follower, type: :follower, followable: followable, action: action }
               ])
    else
      Fail.new('Missing required notification inputs')
    end
  end

  def build_messages(targets:, **)
    targets.each do |target|
      message = case target[:type]
                when :upcoming
                  "Evento '#{target[:event].title}' vai acontecer amanhã!"
                when :owner
                  "#{target[:follower].name} #{follow_action_word(target[:action])} #{followable_description(target[:followable])}"
                when :follower
                  "Você #{follow_action_word(target[:action])} #{followable_description(target[:followable])}"
                end

      target[:message] = message
    end

    Continue(targets: targets)
  end

  def render_htmls(targets:, **)
    targets.each do |target|
      target[:html] = render_html(target[:message])
    end

    Continue(targets: targets)
  end

  def broadcast_all(targets:, **)
    targets.each do |target|
      message = { html: target[:html] }

      NotificationsChannel.broadcast_to(target[:user], message)
    end

    Continue()
  end

  def render_html(message)
    ApplicationController.renderer.render(
      partial: 'notifications/notification',
      locals: { message: message }
    )
  end

  def extract_followable_owner(followable)
    case followable
    when User then followable
    when Article, Event then followable.user
    else raise ArgumentError, 'Unknown followable type'
    end
  end

  def followable_description(followable)
    case followable
    when User then 'você'
    when Article, Event
      "seu #{followable.model_name.human.downcase} \"#{followable.title}\""
    else
      'um conteúdo seu'
    end
  end

  def follow_action_word(action)
    case action.to_sym
    when :created then 'começou a seguir'
    when :destroyed then 'deixou de seguir'
    else 'interagiu com'
    end
  end
end
