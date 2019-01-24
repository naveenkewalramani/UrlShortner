class UrlreportsController < ApplicationController
	
	def index
    	@urlreport = Urlreport.all
    	render 'index'
  	end
end
