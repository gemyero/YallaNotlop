OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '362331179142-vpfmt11trerk072pp9utcvmr3bcu9hl8.apps.googleusercontent.com', 'OTeHaDpg-I6ZhWnns6Ggzpkv'
end