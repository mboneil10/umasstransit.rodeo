source 'https://rubygems.org'

gem 'coffee-rails'
gem 'factory_girl_rails'
gem 'haml'
gem 'haml-lint'
gem 'haml-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'mysql'
gem 'rails', '~> 4.2'
gem 'rubocop'
gem 'sass-rails'
gem 'uglifier'
gem 'underscore-rails'

group :production do
  gem 'exception_notification'
end

group :development do
  gem 'capistrano', require: false
  gem 'capistrano-pending', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-passenger', require: false
end

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'codeclimate-test-reporter'
  gem 'mocha'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'timecop'
end