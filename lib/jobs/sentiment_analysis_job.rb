class SentimentAnalysisJob < Struct.new(:tweet_text,:tweet_id,:language)
  def perform1
    puts "hai"
  end
  def perform
    url = Constants::HPOnDemandAPI::BASE_URL+Constants::HPOnDemandAPI:: SentimentAnalysis::END_POINT
    # Get the api key from lib/constants.rb.
    api_key =  Constants::HPOnDemandAPI::KEY
    # Parse the url.
    uri = URI.parse(url)
    # Encode the required parameters into the url.
    uri.query = URI.encode_www_form(
      'text' => tweet_text,'apikey'=>api_key,'language'=>language
      )
    # Use the rest_client to get the results from the sentiment analysis api  # and conver the response to JSON response.
    @results = JSON.parse(RestClient.get(uri.to_s))
    # @results contains the response object, now pass it to the find.html.erb # page
    puts @results
    $redis_client.hset("sentiment_analysis_cache",tweet_id,@results)
  end
end

