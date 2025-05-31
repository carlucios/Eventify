class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy file_view ]
  before_action :allow_turbo_only, except: %i[ index ]

  def index
    @articles = article_repo.all
  end

  def show
    follow = current_user.follows_as_follower.find_by(followable: @article)
    author_follow = current_user.follows_as_follower.find_by(followable: @article.user)
  end

  def new
    @article = article_repo.new
  end

  def edit
  end

  def create
    @article = article_repo.create(article_params.merge(user_id: current_user.id))

    if @article.persisted?
      redirect_to @article, notice: "Article was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: "Article was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy!
    redirect_to articles_path, notice: "Article was successfully destroyed.", status: :see_other
  end

  def file_view
    render partial: "articles/file_view", locals: { article: @article }
  end  

  private
    def set_article
      @article = article_repo.find(params[:id])
    end

    def allow_turbo_only
      unless turbo_frame_request?
        redirect_to root_path and return
      end
    end

    def article_repo
      @article_repo ||= ArticleRepository.new
    end
  
    def article_params
      params.require(:article).permit(:title, :abstract, :content)
    end
end
