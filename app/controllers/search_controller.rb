class SearchController < ApplicationController

	def search
 		if params[:url].nil?
  			@url = []
 		else
 			@url = Url.search(params[:url].gsub('/','//'))
 		end
	end
end