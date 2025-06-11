# frozen_string_literal: true

# :reek:UtilityFunction

# Provides data access methods for the Article model, encapsulating common queries.
# Inherits from BaseRepository to ensure a consistent interface across repositories.
# Includes custom query to retrieve articles by user, ordered by creation date.
class ArticleRepository < BaseRepository
  def initialize
    super(Article)
  end

  def by_user(user)
    Article.where(user: user).order(created_at: :desc)
  end
end
