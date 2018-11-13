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
  enum role: {
    normal:   0,
    admin:    1
  }
  has_many :user_tokens
  has_many :user_rooms
  has_many :rooms, :through => :user_rooms
  has_secure_password
end

class Room < ActiveRecord::Base
  has_many :user_rooms
  has_many :users, :through => :user_rooms
  has_secure_password
end

class UserRoom < ActiveRecord::Base
  belongs_to :user
  belongs_to :room
end

class UserToken < ActiveRecord::Base
  belongs_to :user
end
