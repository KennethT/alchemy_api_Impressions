class WelcomeController < ApplicationController

  def index
    #twitter query
    if params[:search_term1].present?
      @tweet1 = $twitter.search("#{params[:search_term1]}", result_type: "recent", lang: "en", geo_enabled: "true").take(100)

      #aggregate blob of twitter query
      @twitterblob = @tweet1.map do |tweet|
        tweet.text
      end.join(', ')
      #search term in uri format
      @search_term_uri = URI.escape(params[:search_term1])

      #sentiment associated with tweets
      #mixed: 1 == true, type: positive, negative or neutral, score - sentiment strength
      @sentiment = AlchemyAPI.search(:sentiment_analysis, text: @twitterblob)
      #entity extraction associated with tweets
      @entity = AlchemyAPI.search(:entity_extraction, text: @twitterblob)
      #keyword extraction associated with tweets
      @keyword = AlchemyAPI.search(:keyword_extraction, sentiment: "1", maxRetrieve: "40", text: @twitterblob)

      #stackoverflow api call
      conn = Faraday.new(:url => 'https://api.stackexchange.com')
      # post request to watson personality insights api
      stackoverflow_response1 = conn.get do |req|
        req.url "/2.2/search/advanced?order=desc&sort=activity&q=#{@search_term_uri}&site=stackoverflow"
      end

      @stackoverflowresponse = stackoverflow_response1.body

    end

  end

end
