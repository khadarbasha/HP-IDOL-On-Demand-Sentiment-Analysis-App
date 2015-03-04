module TweetsHelper
  # Helper method will be used to get the response from the sentiment analysis
  # api.
  #
  # => text = string to which sentiment has to be calculated.
  # => language_id = language_id of the string.
  #
  # Examples
  #   sentiment_analysis("sample text","eng")
  #
  # Returns the sentiment analysis api's response.
  def sentiment_analysis(text, language_id)
    # Prepare the url by appending the base url with the api's end point.
    url = Constants::HPOnDemandAPI::BASE_URL+Constants::HPOnDemandAPI:: SentimentAnalysis::END_POINT
    # Get the api key from lib/constants.rb.
    api_key =  Constants::HPOnDemandAPI::KEY
    # Parse the url.
    uri = URI.parse(url)
    # Encode the required parameters into the url.
    uri.query = URI.encode_www_form(
      'text' => text,'apikey' => api_key,'language' => language_id
      )
    # Use the rest_client to get the results from the sentiment analysis api  # and convert the response to the JSON response.
    @results = JSON.parse(RestClient.get(uri.to_s))
  end
  # Helper method will be used to get the response from the language
  # detection api.
  #
  # => text = string to which sentiment has to be calculated.
  #
  # Examples
  #   sentiment_analysis("sample text")
  #
  # Returns the language identification api's response.
  def language_detection(text)
    # Prepare the url by appending the base url with the api's end point.
    url = Constants::HPOnDemandAPI::BASE_URL +
    Constants::HPOnDemandAPI:: LanguageIdentification::END_POINT
    # Get the api key from lib/constants.rb.
    api_key =  Constants::HPOnDemandAPI::KEY
    # Parse the url.
    uri = URI.parse(url)
    # Encode the required parameters into the url.
    uri.query = URI.encode_www_form(
      'text' => text,'apikey' => api_key
      )
    # Use rest_client to get the results from the language identification api
    # and convert the response to JSON response.
    @results = JSON.parse(RestClient.get(uri.to_s))
  end
  # Helper method will be used to get the response from the text highlate
  # api.
  #
  # => text = string to which text has to be highlated.
  # => highlate_expression = Expressions seperated by a comma or space or +.
  #
  # Examples
  #   sentiment_analysis("text sample text","text")
  #
  # Returns the highlated text.
  def text_highlate(text, highlate_expression)
    # Prepare the url by appending the base url with the api's end point.
    url = Constants::HPOnDemandAPI::BASE_URL +
    Constants::HPOnDemandAPI::HighlightText::END_POINT
    # Get the api key from lib/constants.rb.
    api_key =  Constants::HPOnDemandAPI::KEY
    # Parse the url.
    uri = URI.parse(url)
    # Encode the required parameters into the url.
    uri.query = URI.encode_www_form(
      'text' => text,'apikey' => api_key,'highlight_expression' => highlate_expression
      )
    # Use rest_client to get the results from the text highlate api
    # and convert the response to JSON response.
    @results = JSON.parse(RestClient.get(uri.to_s))
  end
end