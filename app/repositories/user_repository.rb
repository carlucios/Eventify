# frozen_string_literal: true

class UserRepository < BaseRepository
  def initialize
    super(User)
  end

  def researchers
    User.where(role: 'researcher')
  end

  def by_email(email)
    User.find_by(email: email)
  end
end
