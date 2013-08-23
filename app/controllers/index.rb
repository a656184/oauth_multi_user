get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  p request_token
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

  username = @access_token.params[:screen_name]
  token = @access_token.params[:oauth_token]
  secret = @access_token.params[:oauth_secret_token]

  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)
  
  User.create(username: username, oauth_token: token, oauth_secret: secret)
  # at this point in the code is where you'll need to create your user account and store the access token

  erb :index
  
end
