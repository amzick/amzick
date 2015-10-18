# environments.rb

#The environment variable DATABASE_URL should be in the following format:
# => postgres://{user}:{password}@{host}:{port}/path
configure :production, :development do

  puts "\n\n"
  puts ENV['DATABASE_URL']
  puts "\n\n"


  db = URI.parse( ENV['DATABASE_URL'] || 'postgres://localhost/amzick' )

  ActiveRecord::Base.establish_connection(
      :adapter => 'postgres',
      # :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      :host     => db.host,
      :username => db.user,
      :password => db.password,
      :database => db.path[1..-1],
      :encoding => 'utf8'
  )
end

# establish_connection(
#   adapter: 'mysql2',
#   encoding: 'utf8',
#   reconnect: true,
#   database: 'app_production',
#   pool: 40,
#   username: 'root',
#   password: 'secretpassword',
#   socket: '/var/run/mysqld/mysqld.sock',
#   host: '12.34.56.78'
# )