class SearchController < ApplicationController

	def search
 		if params[:q].nil?
  			@url = []
 		else
			puts params[:q].gsub('/','//')
 			@url = Url.search(params[:q].gsub('/','//'))
 		end
	end
end
