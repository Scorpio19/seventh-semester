require 'sinatra'

#Dir[File.dirname(__FILE__) + '/models'].each {|file| require file }
#Dir[File.dirname(__FILE__) + '/controllers'].each {|file| require file }

get '/' do
  haml :index
  #http://code.tutsplus.com/tutorials/an-introduction-to-haml-and-sinatra--net-14858
end

# Admin stuff
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
