class WelcomeController < ApplicationController

  def index
    #twitter query
    if params[:search_term1].present?
      @tweet1 = $twitter.search("#{params[:search_term1]}", result_type: "recent", lang: "en", geo_enabled: "true").take(100)

      #aggregate blob of twitter query
      @twitterblob = @tweet1.map do |tweet|
        tweet.text
      end.join(', ')

      #unparsed json response from keyword extraction
      @keywordresult = AlchemyAPI.search(:keyword_extraction, text: @twitterblob)
    end

  end

end
