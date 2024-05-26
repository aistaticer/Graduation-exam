Rails.application.config.middleware.use OmniAuth::Builder do
  #OmniAuth.config.allowed_request_methods = [:post, :get]
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
    redirect_uri: "https://evolution-recipes-949263457034.herokuapp.com/users/auth/google_oauth2/callback"
  }
end