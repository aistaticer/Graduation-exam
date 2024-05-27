Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth.config.allowed_request_methods = [:post, :get]
  redirect_uri = if Rails.env.production?
                   "https://evolution-recipes-949263457034.herokuapp.com/users/auth/google_oauth2/callback"
                 else
                   "http://localhost:3000/users/auth/google_oauth2/callback"
                 end

  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
    redirect_uri: redirect_uri
  }
end