require 'sinatra'
require 'haml'
require 'active_record'
require 'json'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'soccer.db'
)

require_relative 'schema.rb'
require_relative 'controllers/user_controller'
require_relative 'controllers/poll_controller'
require_relative 'controllers/pick_controller'
require_relative 'models/user'
require_relative 'models/poll'
require_relative 'models/pick'

enable :sessions

def get_and_clear_message
  if session[:message]
    message = session[:message]
    session[:message] = nil
  end
  message
end

get '/' do
  session[:user] = nil
  haml :index, locals: {message: get_and_clear_message} 
end

# User registration
get '/register' do
  haml :register, locals: {message: get_and_clear_message}
end

post '/register' do
  user = UserController.register(params[:username], params[:password])
  if user.nil? or user.id.nil?
    session[:message] = "Password or username are not valid or Username is taken."
    redirect '/register'
  else
    session[:user] = user
    redirect '/polls'
  end
end

# User authentication
post '/login' do
  user = UserController.login(params[:username], params[:password])
  if user.nil? or user.id.nil?
    session[:message] = "Invalid username or password"
    redirect '/'
  else
    session[:user] = user
    redirect '/polls'
  end
end

# Redirect to start if not logged in
get '*' do
  redirect '/' unless session[:user]
  pass
end

post '*' do
  redirect '/' unless session[:user]
  pass
end

# Home page
get '/polls' do
  users = UserController.results
  poll_count = PollController.all.count
  haml :polls, locals: {user: session[:user], admin: session[:user].admin, 
                        users: users, poll_count: poll_count, message: get_and_clear_message}
end

# User functionality 
get '/pick' do
  poll = PollController.current
  if poll.nil? or poll.id.nil? or poll.status.to_sym != :open
    session[:message] = "Poll has been closed or has concluded. Wait for a new poll to be opened."
    redirect '/polls'
  else
    matches = PollController.matches
    haml :pick, locals: {user: true, admin: false, message: get_and_clear_message, matches: matches}
  end
end

post '/pick' do
  poll = PollController.current
  count = PollController.matches.count
  PickController.create(session[:user].id, poll.id, count, params)
  session[:message] = "Pick saved!"

  redirect '/polls'
end

# Admin functionality

# Admin authorization
get '*' do
  redirect '/polls' unless session[:user].admin
  pass
end

post '*' do
  redirect '/polls' unless session[:user].admin
  pass
end

# Open Poll
get '/open' do
  poll = PollController.current
  if poll.nil? or poll.id.nil? or poll.status.to_sym == :concluded
    haml :open, locals: {user: true, admin: true, message: get_and_clear_message} 
  else
    session[:message] = "There is already an open poll. Close and/or conclude it before opening another"
    redirect '/polls'
  end
end

post '/open' do
  if params[:match_amount] and params[:match_amount].to_i >= 1
    session[:match_amount] = params[:match_amount]
  else
    session[:message] = "There must be at least 1 match"
  end
  haml :open, locals: {user: true, admin: true, match_amount: session[:match_amount], 
                       message: get_and_clear_message} 
end

post '/done' do
  poll = PollController.create(session[:match_amount].to_i, params)

  if poll
    session[:match_amount] = nil
    session[:message] = "Poll opened!"
    redirect '/polls'
  else
    session[:message] = "One or more team names are empty"
    redirect '/open'
  end
end

# Close a Poll
get '/close' do
  poll = PollController.current
  if !poll.nil? and !poll.id.nil? and poll.status.to_sym == :open
    haml :close, locals: {user: true, admin: true} 
  else
    session[:message] = "Poll has already been closed"
    redirect '/polls'
  end
end

post '/close' do
  PollController.close
  session[:message] = "Poll closed!"
  redirect '/polls'
end

# Conclude a Poll
get '/conclude' do
  poll = PollController.current
  if !poll.nil? and !poll.id.nil? and poll.status.to_sym == :closed
    matches = PollController.matches
    haml :conclude, locals: {user: true, admin: true, matches: matches}
  else
    session[:message] = "Poll has not been created or closed yet"
    redirect '/polls'
  end
end

post '/conclude' do
  PollController.conclude(params)
  session[:message] = "Poll concluded!"
  redirect '/polls'
end
