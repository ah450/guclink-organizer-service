source 'https://rubygems.org'
ruby '2.2.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'jwt'
gem 'thin', require: false
gem 'kaminari'
gem 'rails-api'
gem 'annotate'
gem 'redis-rails'
gem 'redis'
gem 'hiredis'
gem 'redis-namespace'
gem 'sidekiq'
gem 'nokogiri'
gem 'cacheable', git: 'git://github.com/ah450/cacheable.git'
gem 'jwt_authenticatable', git: 'git://github.com/ah450/jwt_authenticatable.git'
gem 'guclink_controller_concerns', git: 'git://github.com/ah450/guclink_controller_concerns.git'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'faker'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'pry-rails'
  gem 'email_spec'
end

group :test do
  gem 'codeclimate-test-reporter', require: false
  gem 'shoulda-matchers'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'rails-erd'
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv-vars'
  gem 'capistrano-sidekiq'
  gem 'capistrano-thin'
end
