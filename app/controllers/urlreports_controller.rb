class UrlreportsController < ApplicationController
	
	def index
    	@urlreport = Urlreport.all.order("id ASC")
    	render 'index'
  	end
end
