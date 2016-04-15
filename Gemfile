source 'https://rubygems.org'

gem 'rails', '>= 5.0.0.beta3', '< 5.1'
gem 'sqlite3'
gem 'puma'
gem 'uglifier', '>= 1.3.0'
gem 'bcrypt-ruby'
gem 'responders'
gem 'active_model_serializers'

group :development, :test do
  gem 'factory_girl_rails'
  gem 'json_matchers'
  gem 'pry-rails'
  %w(
    rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support
  ).each do |lib|
    gem lib, git: "https://github.com/rspec/#{lib}.git", branch: 'master'
  end
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
