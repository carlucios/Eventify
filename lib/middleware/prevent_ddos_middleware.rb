# frozen_string_literal: true

class PreventDdosMiddleware
  REPEATED_REQUEST_WINDOW = 1.0
  MAX_REPEATED_REQUESTS = 2
  BLOCK_DURATION = 60

  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    path = request.path
    ip = request.ip
    user = env['warden']&.user

    key_base = "#{user&.email || ip}:#{path}"
    blocked_key = "ddos_blocked:#{key_base}"
    history_key = "ddos_history:#{key_base}"

    now = Time.now.to_f

    ddos_blocked = Rails.cache.read(blocked_key)

    if ddos_blocked
      Thread.current[:webservice_status] ||= {}
      Thread.current[:webservice_status].merge!(
        rps: 0,
        status: 'red',
        ddos_detected: true,
        blocked_path: path,
        user_email: user&.email
      )

      return @app.call(env)
    end

    history = Rails.cache.read(history_key) || []
    history << now
    history.reject! { |t| t < now - REPEATED_REQUEST_WINDOW }
    Rails.cache.write(history_key, history, expires_in: 2 * REPEATED_REQUEST_WINDOW)

    repeated_count = history.size
    ddos_detected = repeated_count > MAX_REPEATED_REQUESTS

    Rails.cache.write(blocked_key, true, expires_in: BLOCK_DURATION) if ddos_detected

    Thread.current[:webservice_status] ||= {}
    Thread.current[:webservice_status].merge!(
      rps: repeated_count,
      status: status_color(repeated_count),
      ddos_detected: ddos_detected,
      blocked_path: (ddos_detected ? path : nil),
      user_email: user&.email
    )

    @app.call(env)
  end

  private

  def status_color(rps)
    case rps
    when 0..5 then 'green'
    when 6..15 then 'orange'
    else 'red'
    end
  end
end
