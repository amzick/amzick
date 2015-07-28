# Gemfile

source 'https://rubygems.org/'
ruby "2.0.0"

gem "sinatra"
gem "activerecord"
gem "sinatra-activerecord"
gem 'sinatra-flash'
gem 'sinatra-redirect-with-flash'
gem 'sinatra-formhelpers-ng'
gem 'compass'
gem 'haml'

gem 'tumblr_client'

group :development do
  gem 'sqlite3'
  gem "tux"
end

group :production do
  gem 'pg'
end

Tumblr.configure do |config|
  config.consumer_key = "adPBCUStfJLM87SWP7a8DhkZoJMqMpUt8zuR9ohYs1TUKeF6oq"
  config.consumer_secret = "3MgmCEMK24dAByB4EUyyk91w1cjYXUfFqZrFAGipd6axiYckOq"
end
