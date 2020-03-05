require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, {adapter: "sqlite3", database: "barbershop.db"}

class YourApplication < Sinatra::Base
  register Sinatra::ActiveRecordExtension
end

class Client < ActiveRecord::Base
end

class Barber < ActiveRecord::Base
end

get '/' do
  erb 'Hello! $)'
end