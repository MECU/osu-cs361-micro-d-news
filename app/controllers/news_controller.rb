require 'uri'
require 'net/http'

class NewsController < ApplicationController
  def index
    params.require(:ticker)

    ticker = params[:ticker]

    results = search_ticker(ticker)['news']

    if params[:date]
      date = DateTime.parse(params[:date].to_s)
      results.reject! do |r|
        r['providerPublishTime'] < date.to_i
      end
    end

    render json: results
  end


  private

  def search_ticker(ticker)
    uri = URI(YAHOO_SEARCH_URL + ticker.upcase)
    results = Net::HTTP.get_response(uri, { 'User-Agent': 'Mozilla/5.0' }).body
    JSON.parse(results)
  end
end
