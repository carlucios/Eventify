# frozen_string_literal: true

module ApplicationCable
  # Connects logged user to his channel
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      decoded_token = JWT.decode(request.params[:token], ENV['DEVISE_JWT_SECRET_KEY'], true, algorithm: 'HS256')
      verified_user = User.find_by(id: decoded_token[0]['sub'])

      verified_user || reject_unauthorized_connection
    rescue JWT::DecodeError
      reject_unauthorized_connection
    end
  end
end
