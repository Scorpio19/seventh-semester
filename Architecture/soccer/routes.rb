require 'sinatra'
require 'haml'
require './controllers/user_controller'

enable :sessions

=begin General redirect if not logged in. ORDER MATTERS
get '*' do
  if (!session[:user])
    redirect '/'
  else
    pass
  end
end
=end

get '/' do
  session[:user] = nil
  haml :index, locals: {error: session[:error]}
end

# User registration
get '/register' do
  haml :register
end

post '/register' do
  if (params[:new])
    UserController.create_user(params[:username], params[:password])
  end
  session[:error] = nil
  redirect '/'
end

# User authentication
post '/polls' do
  session[:error] = nil
  auth = UserController.find_user(params[:username], params[:password])
  if (auth)
    session[:user] = auth
    scores = UserController.get_results
    haml :polls, locals: {user: session[:user], scores: scores}
  else
    session[:user] = nil 
    session[:error] = "Invalid username or password"
    redirect '/'
  end
end

get '/polls' do
  scores = UserController.get_results
  if (!session[:user])
    redirect '/'
  else
    haml :polls, locals: {user: session[:user], scores: scores}
  end
end

# Open Poll
get '/open' do
  if (session[:user].admin)
    haml :open, locals: {user: session[:user]}
  else
    redirect '/polls'
  end
end

post '/open' do
  unless (session[:user].admin)
    redirect '/polls'
  else
    if (params[:match_amount] and params[:match_amount].to_i >= 1)
      haml :open, locals: {user: session[:user], match_amount: params[:match_amount]}
    else
      redirect '/open'
    end
  end
end

post '/done' do
  unless (session[:user].admin)
    redirect '/polls'
  else
    if (params[:a_0])
      #TODO: Create new poll
      #map [a_i: team, b_i: team]
      #i signals match #
      haml :done, locals: {user: session[:user]}
    else
      redirect '/open'
    end
  end
end

# Close a Poll
get '/close' do
  if (session[:user].admin)
    haml :close, locals: {user: session[:user]}
  else
    redirect '/polls'
  end
end

get '/conclude' do
  if (session[:user].admin)
    haml :conclude, locals: {user: session[:user]}
  else
    redirect '/polls'
  end
end

# User stuff

get '/pick' do
  haml :pick, locals: {user: session[:user]}
end
