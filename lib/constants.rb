# Constants module, all the constants decleration will go here.
module Constants
  # All the constants related to HPOnDemandAPI will go here.
  module HPOnDemandAPI
    KEY = "223d84ce-945b-44ba-9d2a-c4a0698f1c65"
    BASE_URL = "https://api.idolondemand.com/1/api/sync"
    # All the constants related to SentimentAnalysisAPI will go here.
    module SentimentAnalysis
      END_POINT = "/detectsentiment/v1"
    end
    # All the constants related to LanguageIdentificationAPI will go here.
    module LanguageIdentification
      END_POINT = "/identifylanguage/v1"
    end
    # All the constants related to HighlightTextAPI will go here.
    module HighlightText
      END_POINT = "/highlighttext/v1"
    end
  end
  # All the constants related to TwitterAPI will go here.
  module TwitterAPI
    KEY = "9VHRYhxN6BAwl7blyEvnAeE0G"
    KEY_SECRET = "meAVQNZO3XjaPS2dMDQoim9KVYcgBvQ8XYKhnAn5AlhC7hv6Vh"
    TOKEN = "2669081881-isWadTB0K1vZsxx5yWtgINgLrnGlL5F3bKiFfkL"
    TOKEN_SECRET = "A8uxTakEC5IbHmppgIpjt7NJ9tcK1Mw1M8zCcy5LAPsOR"
    DEFAULT_INPUT = "f1"
    NUMBERT_OF_TWEETS = 5
  end
end