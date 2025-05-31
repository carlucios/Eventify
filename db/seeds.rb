require 'faker'

puts "🔄 Limpando o banco..."
Follow.destroy_all
Article.destroy_all
Event.destroy_all
User.destroy_all

puts "👤 Criando usuários..."

# Usuário fixo admin
User.create!(
  email: "admin@example.com",
  password: "password",
  password_confirmation: "password",
  name: "Admin",
  role: "admin"
)

# Criando 10 usuários comuns (attendees)
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

# Criando 10 promoters
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

puts "📅 Criando eventos científicos..."

SCI_EVENTS = [
  "International Symposium on Quantum Computing",
  "Global Conference on Artificial Intelligence",
  "World Summit on Renewable Energy",
  "International Workshop on Machine Learning",
  "Annual Congress of Biomedical Research",
  "Symposium on Climate Change and Sustainability",
  "International Conference on Nanotechnology",
  "Forum on Advanced Robotics",
  "Congress on Environmental Sciences",
  "Symposium on Neuroscience and Behavior"
]

SCI_DESCRIPTIONS = [
  "An event dedicated to the latest advances in scientific research and technology.",
  "Bringing together experts and scholars to discuss breakthroughs in AI.",
  "A platform for researchers to present findings on renewable energy solutions.",
  "Workshops and talks on the latest in machine learning algorithms and applications.",
  "A gathering of biomedical researchers presenting innovative studies.",
  "Focus on climate change challenges and sustainability efforts worldwide.",
  "Exploring recent developments in nanotechnology and applications.",
  "Discussions on state-of-the-art robotics and automation.",
  "Research presentations on environmental protection and sustainability.",
  "Latest discoveries in neuroscience and behavioral science."
]

events = promoters.flat_map do |promoter|
  3.times.map do
    start_date = Faker::Date.forward(days: rand(10..60))
    end_date = start_date + rand(1..5)
    idx = rand(SCI_EVENTS.size)
    Event.create!(
      title: SCI_EVENTS[idx],
      description: SCI_DESCRIPTIONS[idx],
      start_date: start_date,
      end_date: end_date,
      address: Faker::Address.full_address,
      latitude: Faker::Address.latitude,
      longitude: Faker::Address.longitude,
      user: promoter
    )
  end
end

puts "📰 Criando artigos científicos..."

SCI_ARTICLES_TITLES = [
  "A Novel Approach to Quantum Entanglement",
  "Deep Learning Techniques for Medical Image Analysis",
  "Renewable Energy Storage Solutions: A Review",
  "Applications of CRISPR in Genetic Engineering",
  "Climate Change Impact on Marine Biodiversity",
  "Nanoparticle Synthesis and Characterization",
  "Advancements in Autonomous Vehicle Technologies",
  "Behavioral Patterns in Primates: A Meta-Analysis",
  "Bioinformatics Tools for Genome Sequencing",
  "Robotics in Surgical Procedures: Current Trends"
]

SCI_ARTICLES_ABSTRACTS = [
  "This study explores the latest techniques in quantum entanglement for secure communications.",
  "We evaluate deep learning models applied to MRI and CT scan data for disease diagnosis.",
  "The article reviews different methods for storing energy generated from renewable sources.",
  "A comprehensive overview of CRISPR gene-editing and its ethical implications.",
  "Assessing the effects of global warming on various marine species and ecosystems.",
  "Details the process of nanoparticle creation and their potential industrial uses.",
  "Examines the development of self-driving cars and their integration in modern transport.",
  "Meta-analysis of observed behavioral trends in various primate species.",
  "Presentation of new bioinformatics software to accelerate genome analysis.",
  "Discusses the role of robots assisting in minimally invasive surgeries."
]

articles = users.flat_map do |user|
  rand(3..7).times.map do
    idx = rand(SCI_ARTICLES_TITLES.size)
    Article.create!(
      title: SCI_ARTICLES_TITLES[idx],
      abstract: SCI_ARTICLES_ABSTRACTS[idx],
      file: "https://example.com/files/scientific_paper_#{rand(1000..9999)}.pdf",
      user: user
    )
  end
end

puts "🔗 Criando follows..."

User.all.each do |user|
  # Seguir de 9 a 12 eventos aleatórios
  events.sample(rand(9..12)).each do |event|
    Follow.create!(follower: user, followable: event)
  end

  # Seguir de 3 a 5 artigos aleatórios
  articles.sample(rand(3..5)).each do |article|
    Follow.create!(follower: user, followable: article)
  end

  # Seguir de 2 a 5 outros usuários (excluindo ele mesmo)
  (users - [user]).sample(rand(2..5)).each do |other_user|
    Follow.create!(follower: user, followable: other_user)
  end
end

puts "✅ Seed finalizado com sucesso!"
