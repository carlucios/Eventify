FactoryBot.define do
  factory :event do
    title { "MyString" }
    description { "MyText" }
    start_date { "2025-05-30 15:11:57" }
    end_date { "2025-05-30 15:11:57" }
    address { "MyString" }
    latitude { 1.5 }
    longitude { 1.5 }
    user { nil }
  end
end
