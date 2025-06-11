# frozen_string_literal: true

namespace :performance do
  desc 'Testa a criação e remoção em massa de follows (User, Event, Article)'
  task follows: :environment do
    require 'benchmark'
    require 'memory_profiler'

    total = ENV['TOTAL'].to_i.positive? ? ENV['TOTAL'].to_i : 1_000
    puts "Iniciando teste com #{total} follows para cada tipo (User, Event, Article)..."

    users = User.limit(total).to_a
    events = Event.limit(total).to_a
    articles = Article.limit(total).to_a

    if users.size < total
      puts 'Criando usuários adicionais para o teste...'
      (total - users.size).times do |i|
        users << User.create!(name: "User #{i}", email: "user#{SecureRandom.uuid}@example.com", password: 'password')
      end
    end

    if events.size < total
      puts 'Criando eventos adicionais para o teste...'
      (total - events.size).times do |i|
        events << Event.create!(title: "Event Test #{i}", user: users.sample)
      end
    end

    if articles.size < total
      puts 'Criando artigos adicionais para o teste...'
      (total - articles.size).times do |i|
        articles << Article.create!(title: "Article Test #{i}", user: users.sample)
      end
    end

    creation_time = Benchmark.realtime do
      total.times do |i|
        follower = users[i % users.size]
        Follow.create!(follower: follower, followable: users[(i + 1) % users.size])
        Follow.create!(follower: follower, followable: events[i % events.size])
        Follow.create!(follower: follower, followable: articles[i % articles.size])
      end
    end

    removal_time = Benchmark.realtime do
      follows_to_remove = Follow.order(created_at: :desc).limit(total * 3)
      follows_to_remove.each(&:destroy)
    end

    # Simulação de tempo de job, aqui você pode substituir pelo real caso tenha job rodando
    simulated_job_time = 1.0 # segundos

    # Usando memory_profiler para medir memória usada durante a criação
    report = MemoryProfiler.report do
      total.times do |i|
        follower = users[i % users.size]
        Follow.create(follower: follower, followable: users[(i + 1) % users.size])
        Follow.create(follower: follower, followable: events[i % events.size])
        Follow.create(follower: follower, followable: articles[i % articles.size])
      end
    end

    memory_used_mb = report.total_allocated_memsize / 1024.0 / 1024.0

    total_follows = total * 3
    efficiency = (total_follows / creation_time).round(2) # follows por segundo
    total_test_time = creation_time + removal_time + simulated_job_time

    puts "\n🧪 RESULTADOS DA PERFORMANCE"
    puts "  • Follows/Unfollows: #{total_follows}"
    puts "  • Tempo total criação: #{creation_time.round(3)}s"
    puts "  • Tempo total remoção: #{removal_time.round(3)}s"
    puts "  • Eficiência de criação: #{efficiency} registros/s"
    puts "  • Tempo de job (simulado): #{simulated_job_time.round(3)}s"
    puts format('  • Memória utilizada: %.1f MB', memory_used_mb)
    puts "  • Status: #{efficiency > 3000 ? '✅ EXCELENTE' : '⚠️ REGULAR'}"
    puts format('  • Tempo total do teste: %.3fs', total_test_time)
  end
end
