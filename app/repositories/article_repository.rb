# frozen_string_literal: true

class ArticleRepository < BaseRepository
  def initialize
    super(Article)
  end

  def by_user(user)
    Article.where(user: user).order(created_at: :desc)
  end
end
