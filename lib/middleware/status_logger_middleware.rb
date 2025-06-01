# frozen_string_literal: true

class StatusLoggerMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    start_time = Time.now
    status, headers, response = @app.call(env)
    duration = ((Time.now - start_time) * 1000).round(2)

    Thread.current[:webservice_status] = {
      status: status(duration),
      duration_ms: duration
    }

    [status, headers, response]
  end

  private

  def status(duration_ms)
    case duration_ms
    when 0..300
      '#28a745'
    when 301..1000
      '#ffc107'
    else
      '#dc3545'
    end
  end
end
