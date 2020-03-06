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

def output_error validate, params
  validate.select {|key,_| params[key] == ''}.values.join(", ")
end

get '/' do
  @barbers = Barber.all
  erb :index
end

get '/visit' do
  @barbers = Barber.all
  erb :visit
end

post '/visit' do

  @error = nil

  validate = {
    :name => "Введите имя",
    :phone => "Введите телефон",
    :datestamp => "Введите дату и время"
  }

  @barbers = Barber.all

  @name = params[:name]
  @phone = params[:phone]
  @datestamp = params[:datestamp]
  @barber = params[:barber]
  @color = params[:color]

  @error = output_error(validate, params)

  if !@error.empty?
    return erb :visit
  end

    @error = nil

    Client.create(:name => @name, :phone => @phone, :datestamp => @datestamp,  :barber => @barber, :color => @color)

    erb "Мастер #{@barber} ждем вас к #{@datestamp}."

end