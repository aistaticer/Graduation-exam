if Rails.env.production?
  Rails.application.config.session_store :cookie_store, key: '_my_session', expire_after: 1.weeks, domain: 'evolution-recipes'
else
  Rails.application.config.session_store :cookie_store, key: '_my_session', domain: 'localhost:3000/'
end