class SearchController < ApplicationController
	def search
 		if params[:q].nil?
  			@url = []
 		else
 			puts ;
 			#puts params[:q]
 			@url = Url.search(params[:q].gsub('/','//'))
 		end
	end
end
