$twitter_client = Twitter::REST::Client.new do |config|
  config.consumer_key        = Constants::TwitterAPI::KEY
  config.consumer_secret     = Constants::TwitterAPI::KEY_SECRET
  config.access_token        = Constants::TwitterAPI::TOKEN
  config.access_token_secret = Constants::TwitterAPI::TOKEN_SECRET
end