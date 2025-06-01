# frozen_string_literal: true

# Every route require authentication
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
end
