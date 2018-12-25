Lastfm.configure do |config|
  config.base_url = "http://ws.audioscrobbler.com/"
  config.token = Rails.application.credentials.last_fm_api_key
end
