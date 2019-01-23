class UrlreportsController < ApplicationController
	
	def index
    	@urlreport = Urlreport.all
  	end
 
  	def show
    	@urlreport = Urlreport.find(params[:id])
    	redirect_to '/urlreports'
  	end
end
