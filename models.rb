require 'bundler/setup'
Bundler.require
require 'net/http'
require 'uri'
require 'json'
require './controllers/users'
require './controllers/rooms'
require './controllers/chats'
require './controllers/game_logs'

config = YAML.load_file('./database.yml')

ActiveRecord::Base.configurations = config
if development?
  ActiveRecord::Base.establish_connection(config['development'])
else
  ActiveRecord::Base.establish_connection(config['production'])
end

Time.zone = 'Tokyo'
ActiveRecord::Base.default_timezone = :local

after do
  ActiveRecord::Base.connection.close
end

class User < ActiveRecord::Base
end
