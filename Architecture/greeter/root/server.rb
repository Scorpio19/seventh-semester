require 'sinatra'
require './models/greeter_factory'

configure do
  enable :sessions
end

get '/' do
  @languages = GreeterFactory.available_languages
  erb :index
end

post '/' do
  session[:language] = params[:language] || 'English'
  redirect '/greet'
end

get '/greet' do
  @greeter = GreeterFactory.create(session[:language])
  erb :greet
end
