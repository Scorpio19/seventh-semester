require 'sinatra'
require 'haml'

get '/' do
  haml :index
end

# Admin stuff
post '/open' do
  params[:password]
end

get '/open' do
  haml :open, locals: {title: "Open"}
end

get '/close/:id' do
end

get '/conclude/:id' do
end

get '/addAdmin' do
end

# User stuff
get '/register' do
end

get '/pick/:id' do
end

# General stuff

get '/polls/:id' do
end

get '/results' do
end
