class WelcomeController < ApplicationController

  def index
    #twitter query
    if params[:search_term1].present?
      @tweet1 = $twitter.search("#{params[:search_term1]}", result_type: "recent", lang: "en", geo_enabled: "true").take(100)

      #aggregate blob of twitter query
      @twitterblob = @tweet1.map do |tweet|
        tweet.text
      end.join(', ')
      #twitter blob in uri format
      @search_term_uri = URI.escape(params[:search_term1])

      #sentiment associated with tweets
      #mixed: 1 == true, type: positive, negative or neutral, score - sentiment strength
      @sentiment = AlchemyAPI.search(:sentiment_analysis, text: @twitterblob)
      #entity extraction associated with tweets
      @entity = AlchemyAPI.search(:entity_extraction, text: @twitterblob)
      #keyword extraction associated with tweets
      @keyword = AlchemyAPI.search(:keyword_extraction, sentiment: "1", maxRetrieve: "40", text: @twitterblob)
    end

  end

end
