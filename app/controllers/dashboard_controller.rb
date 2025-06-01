# frozen_string_literal: true

# Controller responsible for managing dashboard.
class DashboardController < ApplicationController
  def index
    followed_users = current_user.following_users
    @followed_events = (current_user.following_events + followed_users.flat_map(&:events)).uniq
    @followed_articles = followed_users.flat_map(&:articles).uniq
    @all_events = EventRepository.new.all
    @all_articles = ArticleRepository.new.all
  end
end
