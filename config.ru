# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

require_relative './lib/middleware/status_logger_middleware'

use StatusLoggerMiddleware

run Rails.application
Rails.application.load_server
