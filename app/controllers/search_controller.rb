class SearchController < ApplicationController
=begin
  **Request Type:** GET 
  **Routes:** url_search_path
  **Description:** his action is called in order to perfrom elatic search.The input parameters are serach 
  corressponding to inverted index created by default.The search results are shown on search.html.erb file
=end  
  def search
    if params[:url].nil?
      @url = []
    else
      @url = Url.search(params[:url].gsub('/','//'))
    end
  end
end
