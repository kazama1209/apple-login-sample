Rails.application.config.middleware.use OmniAuth::Builder do
	provider :apple, ENV['CLIENT_ID'], '',
           {
             scope: 'email name',
             team_id: ENV['TEAM_ID'],
             key_id: ENV['KEY_ID'],
             pem: ENV['APPLE_PRIATE_KEY'],
           }
end