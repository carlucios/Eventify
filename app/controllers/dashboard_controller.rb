class DashboardController < ApplicationController
  def index
    @followed_events = (current_user.following_events + current_user.following_users.flat_map(&:events)).uniq
    @followed_articles = (current_user.following_articles + current_user.following_users.flat_map(&:articles)).uniq
    @all_events = EventRepository.new.all
    @all_articles = ArticleRepository.new.all
  end
end
