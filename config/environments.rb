# environments.rb

#The environment variable DATABASE_URL should be in the following format:
# => postgres://{user}:{password}@{host}:{port}/path
configure :production, :development do
  db = ENV['DATABASE_URL'] || 'postgres://localhost/amzick'

  ActiveRecord::Base.establish_connection( db )
end

