# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    title { 'MyString' }
    abstract { 'MyText' }
    file { 'MyString' }
    user { nil }
  end
end
