class TweetsController < ApplicationController
  include TweetsHelper
  # Controller method will invoke the corresponding view page(home.html.erb)
  #
  #
  # Examples
  #   home
  #
  # Invoke the home.html.erb page.
  def home
  end
  # Controller method will call the twitter api to fetch the tweets with the
  # provided hash tag. Every tweet will be passed to language detection api to
  # fetch the language code, and then text along with the language code will
  # be passed to sentiment analysis api to calculate the sentiment of the text.
  #
  # => params[:user_pick][:hash_tag] = user's input received from the index.
  # html.erb page
  #
  # Examples
  #   search
  #
  # Redirect the user to the search.hrml.erb page with the response received
  # from sentiment analysis api.
  def search
    # Set the input to default if the user not passed any input.
    params[:user_pick][:hash_tag] = Constants::TwitterAPI::DEFAULT_INPUT if params[:user_pick][:hash_tag].empty?
    # Prepare the input data to get the hash tag response from twitter api.
    hash_tag = "#"+params[:user_pick][:hash_tag]+" -rt"
    # Get the tweets from twitter api. And store them in @tweets object.
    @tweets = $twitter_client.search(hash_tag)
    @api_responses = Array.new
    cnt = 0
    # Iterate through every tweet.
    @tweets.each do |tweet|
      # Find out the language of the tweet text.
      language_detection_result = language_detection(tweet.text)
      # Extract the language_id from the language_detection.
      language_id = language_detection_result["language_iso639_2b"].downcase
      # These are the supported languages by the sentiment analysis api.
      supported_ids = ["eng","fre","spa","ger","ita","chi"]
      # Set english as default language_id.
      language_id = "eng" if !(supported_ids.include?language_id)
      # Get the response from sentiment analysis api.
      sentiment_analysis_result = sentiment_analysis(tweet.text, language_id)
      # For every tweet store it's id, text, language and sentiment analysis
      # response in the response object.
      @api_responses.push ({
        "id" => tweet.id,
        "text"=> tweet.text,
        "language" => language_detection_result["language"],
        "sentiment_analysis" => sentiment_analysis_result
        })
      cnt += 1
      # Break the loop if the number of tweets processed are more than the
      # NUMBER_OF_TWEETS from lib/constants.rb
      break if cnt > (Constants::TwitterAPI::NUMBERT_OF_TWEETS).to_i
    end
    # Forward the reponse object to the search.html.erb page.
    @api_responses
  end
  # Controller method will call the twitter api to fetch the tweets with the
  # provided tweet id. For the tweet text, sentiment analysis score will be
  # calculated along with the strings responsible for the sentiment. Top 5
  # strings those are responsible for positive and negative sentiment will be
  # forwarded to highlate api along with tweet text to get the highlated text.
  #
  # => params[:id] = id of the tweet.
  #
  # Examples
  #   view
  #
  # Redirect the user to the view.hrml.erb page with the response received
  # from sentiment analysis api, language detection api and highlate text api.
  def view
    # Initialize the response object.
    @response = Hash.new
    # Get the twitter response for the twitter id received from search.html.erb
    tweet = $twitter_client.status(params[:id])
     # Find out the language of the tweet text.
     language_detection_result = language_detection(tweet.text)
    # Extract the language_id from the language_detection.
    language_id = language_detection_result["language_iso639_2b"].downcase
    # These are the supported languages by the sentiment analysis api.
    supported_ids = ["eng","fre","spa","ger","ita","chi"]
    # Set english as default language_id.
    language_id = "eng" if !(supported_ids.include?language_id)
    # Get the response from sentiment analysis api.
    sentiment_analysis_result = sentiment_analysis(tweet.text, language_id)
    # Set the tweet text in response object.
    @response["tweet_text"] = tweet.text
    # Set the language in response object.
    @response["language"] = language_detection_result["language"]
    # Set the sentiment analysis result in response object.
    @response["sentiment_analysis"] = sentiment_analysis_result
    # Set tweet text as default highlated text.
    @response["text_highlate"] = tweet.text
    # Get the sentiment.
    sentiment =  sentiment_analysis_result["aggregate"]["sentiment"]
    # Initialize an emapty arry to hold the strings responsible for positive
    # sentiment.
    list_positive_sentiment = []
    # Load the list_positive_sentiment array with the strings.
    sentiment_analysis_result["positive"].each do |result|
      list_positive_sentiment.push(result["sentiment"]) if result["sentiment"] != "null" || result["sentiment"] !=nil || result["sentiment"].size > 0
    end
    # Initialize an emapty arry to hold the strings responsible for negative
    # sentiment.
    list_negative_sentiment = []
    # Load the list_positive_sentiment array with the strings.
    sentiment_analysis_result["negative"].each do |result|
      list_negative_sentiment.push(result["sentiment"]) if result["sentiment"] != "null" || result["sentiment"] !=nil || result["sentiment"].size > 0
    end
    # Just keep the top 5 strings in the list_negative_sentiment arrray.
    list_negative_sentiment = list_negative_sentiment[0..4] if list_negative_sentiment.size > 5
    # Just keep the top 5 strings in the list_positive_sentiment arrray.
    list_positive_sentiment = list_positive_sentiment[0..4] if list_positive_sentiment.size > 5
    # Convert the list to string and join each string by comma.
    positive_sentiment_string = list_positive_sentiment.join(",")
    # Convert the list to string and join each string by comma.
    negative_sentiment_string = list_negative_sentiment.join(",")
    # Append both positve and negative sentiment string lists.
    sentiment_string = positive_sentiment_string+negative_sentiment_string
    # Set the positive sentiment string in response object.
    @response["sentiment_words_positive"] = positive_sentiment_string
    # Set the negative sentiment string in response object.
    @response["sentiment_words_negative"] = negative_sentiment_string
    # Forward to text highlate api iff there exisits at least one string in
    # the sentiment_string.
    if sentiment_string.size > 0
      puts "sentiment_string is :#{sentiment_string}"
      @response["text_highlate"] = text_highlate(tweet.text, sentiment_string)["text"]
    end
    # Forward the response object to the view.html.erb page.
    @response
  end
end