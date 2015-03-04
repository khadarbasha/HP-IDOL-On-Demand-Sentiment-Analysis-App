SentimentAnalysisAPI::Application.routes.draw do
  # Home page route.
  root :to=> "tweets#home"
  # Search page route.
  match "/search" => 'tweets#search', :as => :search_tweets
  # View page route.
  match ":id/view" => 'tweets#view', :as => :tweet_view
end
