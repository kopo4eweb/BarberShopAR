require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, {adapter: "sqlite3", database: "barbershop.db"}

class YourApplication < Sinatra::Base
  register Sinatra::ActiveRecordExtension
end

class Client < ActiveRecord::Base
  validates :name, presence: true, length: {minimum: 2}
  validates :phone, presence: true
  validates :datestamp, presence: true
  validates :color, presence: true
end

class Barber < ActiveRecord::Base
end

class Contact < ActiveRecord::Base
end

def output_error validate, params
  validate.select {|key,_| params[key] == ''}.values.join(", ")
end

get '/' do
  @barbers = Barber.all
  erb :index
end

get '/barber/:id' do
  @barber = Barber.find(params[:id])
  erb :barber
end

get '/visit' do
  @barbers = Barber.all
  @c = Client.new 

  erb :visit
end

post '/visit' do

  @error = nil

  @barbers = Barber.all

  @c = Client.new params[:client]
  if @c.save
    erb "<h2>Спасибо, вы записались!</h2>"
  else
    @error = @c.errors.full_messages.uniq.join(", ")
    erb :visit
  end

end

get '/contacts' do
  erb :contacts
end

post '/contacts' do

  @error = nil

  validate = {
    :email => "Введите email",
    :user_message => "Введите сообщение"
  }

  @email = params[:email]
  @user_message= params[:user_message]

  @error = output_error(validate, params)

  if !@error.empty?
    return erb :contacts
  end
  
  @error = nil

  Contact.create(:email => @email, :user_message => @user_message)

  erb "Спасибо за обращение, мы вам обязательно вам ответим по этому адресу #{@email}."
  
end

get '/clients' do
  @clients = Client.all  
  erb :clients
end