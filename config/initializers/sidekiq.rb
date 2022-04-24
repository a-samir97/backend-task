sidekiq_config = { url: "#{ENV['REDIS_URL']}" }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
  ActiveRecord::Base.establish_connection(
    { :adapter => 'mysql2',
       :database => "#{ENV['DB_NAME']}",
       :host => "#{ENV['DB_HOST']}",
       :username => "#{ENV['DB_USER']}",
       :password => "#{ENV['DB_PASSWORD']}" }
  )
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end