# frozen_string_literal: true

FactoryBot.define do
  factory :follow do
    follower { nil }
    followed { nil }
  end
end
