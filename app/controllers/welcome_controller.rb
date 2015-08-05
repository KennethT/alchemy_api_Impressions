class WelcomeController < ApplicationController

  def index
    if params[:search_term1].present?
      #twitter query and aggregate blob of twitter query
      @tweet1 = $twitter.search("#{params[:search_term1]}", result_type: "recent", lang: "en", geo_enabled: "true").take(100)
      @twitterblob = @tweet1.map do |tweet|
        tweet.text
      end.join(', ')
      #search term in uri format
      @search_term_uri = URI.escape(params[:search_term1])

      #AlchemyAPI calls analyzing twitter
      @entity = AlchemyAPI.search(:entity_extraction, text: @twitterblob)
      @keyword = AlchemyAPI.search(:keyword_extraction, sentiment: "1", maxRetrieve: "40", text: @twitterblob)

      # stackoverflow api call
      conn = Faraday.new(:url => 'https://api.stackexchange.com')
      @stackoverflow_response1 = conn.get do |req|
        req.url "/2.2/search/advanced?order=desc&sort=activity&q=#{@search_term_uri}&site=stackoverflow"
      end

      # @stackoverflow1 = JSON.parse(@stackoverflow_response1.body)["items"]

      @stackoverflow1 = JSON.parse(@stackoverflow_response1.body)

      def tagparser(json)
        new_array = []
            json['items'].each do |item|
                new_array.push(item['title'])
        end
        return new_array.join(", ")
      end

      @teststring = tagparser(@stackoverflow1)

      #AlchemyAPI calls analyzing stackoverflow
      @entity2 = AlchemyAPI.search(:entity_extraction, text: @teststring)
      @keyword2 = AlchemyAPI.search(:keyword_extraction, sentiment: "1", maxRetrieve: "40", text: @teststring)

    end

  end

end
