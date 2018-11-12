require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'pry' if development?
require 'sinatra-websocket'
require './models'

set :server, 'thin'
set :sockets, []

before do
  content_type :json
  headers 'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => %w[GET POST PUT DELETE OPTIONS]
end

not_found do
  {
    error: 404
  }.to_json
end
