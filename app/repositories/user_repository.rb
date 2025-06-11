# frozen_string_literal: true
# :reek:UtilityFunction

# Provides data access methods for the User model.
# Inherits basic CRUD operations from BaseRepository.
# Includes custom queries for fetching users by role (e.g., researchers)
# and retrieving users by email address.
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
