require 'faker'

puts "🔄 Limpando o banco..."
Follow.destroy_all
Article.destroy_all
Event.destroy_all
User.destroy_all

puts "👤 Criando usuários..."

# Usuário fixo admin
User.create!(
  email: "carlucios@gmail.com",
  password: "password",
  password_confirmation: "password",
  name: "Carlucios",
  role: "admin"
)

# Criando 100 usuários comuns (attendees)
users = 10.times.map do
  User.create!(
    email: Faker::Internet.unique.email,
    password: "password",
    password_confirmation: "password",
    name: Faker::Name.name,
    role: "attendee",
    address: Faker::Address.full_address
  )
end

# Criando 50 promoters
promoters = 10.times.map do
  User.create!(
    email: Faker::Internet.unique.email,
    password: "password",
    password_confirmation: "password",
    name: Faker::Name.name,
    role: "promoter",
    address: Faker::Address.full_address
  )
end

puts "📅 Criando eventos..."

events = promoters.flat_map do |promoter|
  3.times.map do
    start_date = Faker::Date.forward(days: rand(10..60))
    end_date = start_date + rand(1..5)
    Event.create!(
      title: Faker::Music.album + " Conference",
      description: Faker::Lorem.paragraphs(number: 2).join("\n\n"),
      start_date: start_date,
      end_date: end_date,
      address: Faker::Address.full_address,
      latitude: Faker::Address.latitude,
      longitude: Faker::Address.longitude,
      user: promoter
    )
  end
end

puts "📰 Criando artigos..."

articles = users.flat_map do |user|
  rand(3..7).times.map do
    Article.create!(
      title: Faker::Book.title,
      abstract: Faker::Lorem.paragraphs(number: 3).join("\n\n"),
      file: Faker::Internet.url(host: 'example.com', path: '/files/sample.pdf'),
      user: user
    )
  end
end

puts "🔗 Criando follows..."

User.all.each do |user|
  events.sample(rand(9..12)).each do |event|
    Follow.create!(follower: user, followable: event)
  end

  articles.sample(rand(3..5)).each do |article|
    Follow.create!(follower: user, followable: article)
  end

  (users - [user]).sample(rand(2..5)).each do |other_user|
    Follow.create!(follower: user, followable: other_user)
  end
end

puts "✅ Seed finalizado com sucesso!"
