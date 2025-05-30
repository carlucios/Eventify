class ArticleRepository
  def all
    Article.includes(:user).order(created_at: :desc)
  end

  def find(id)
    Article.find_by(id: id)
  end

  def create(params)
    Article.create(params)
  end

  def update(article, params)
    article.update(params)
  end

  def destroy(article)
    article.destroy
  end

  def by_user(user)
    Article.where(user: user).order(created_at: :desc)
  end
end
