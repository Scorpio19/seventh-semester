require 'sinatra'
require 'haml'
require 'active_record'

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

get '/' do
  session[:user] = nil
  if session[:message]
    message = session[:message]
    session[:message] = nil
  end
  haml :index, locals: {message: message} 
end

# User registration
get '/register' do
  haml :register, locals: {message: session[:message]}
end

post '/register' do
  user = UserController.create_user(params[:username], params[:password])
  unless user
    session[:message] = "Password or username are not valid or Username is taken."
    redirect '/register'
  else
    session[:message] = nil
    session[:user] = user
    redirect '/polls'
  end
end

# User authentication
post '/login' do
  session[:message] = nil
  user = UserController.find_user(params[:username], params[:password])
  if (user)
    session[:user] = user
    redirect '/polls'
  else
    session[:message] = "Invalid username or password"
    redirect '/'
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
  users = UserController.get_results
  poll_count = PollController.all.count
  if session[:message]
    message = session[:message]
    session[:message] = nil
    haml :polls, locals: {user: true, admin: session[:user].admin, users: users, poll_count: poll_count, message: message}
  else
    haml :polls, locals: {user: true, admin: session[:user].admin, users: users, poll_count: poll_count}
  end
end

# User functionality 
get '/pick' do
  poll = PollController.get_poll
  if poll.status != :open
    session[:message] = "Poll has been closed or has concluded. Wait for a new poll to be opened."
    redirect '/polls'
  else
    haml :pick, locals: {user: true, admin: false, message: session[:message], poll: poll}
  end
end

post '/pick' do
  poll = PollController.get_poll
  user = session[:user]
  pickParams = params

  PickController.create_pick(user, poll, pickParams)
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
  poll = PollController.get_poll
  if poll.status != :concluded
    session[:message] = "There is already an open poll. Close and/or conclude it before opening another"
    redirect '/polls'
  else
    haml :open, locals: {user: true, admin: true, match_amount: session[:match_amount], message: session[:message]}
  end
end

post '/open' do
  if params[:match_amount] and params[:match_amount].to_i >= 1
    session[:match_amount] = params[:match_amount]
  else
    session[:message] = "There must be at least 1 match"
  end
  redirect '/open'
end

post '/done' do
  poll = PollController.create_poll(params)
  unless poll
    session[:message] = "One or more team names are empty"
    redirect '/open'
  else
    session[:match_amount] = nil
    session[:message] = "Poll opened!"
    redirect '/polls'
  end
end

# Close a Poll
get '/close' do
  haml :close, locals: {user: true, admin: true} 
end

post '/close' do
  PollController.close_poll
  session[:message] = "Poll closed!"
  redirect '/polls'
end

# Conclude a Poll
get '/conclude' do
  poll = PollController.get_poll
  haml :conclude, locals: {user: true, admin: true, poll: poll}
end

post '/conclude' do
  PollController.conclude_poll(params)
  session[:message] = "Poll concluded!"
  redirect '/polls'
end
