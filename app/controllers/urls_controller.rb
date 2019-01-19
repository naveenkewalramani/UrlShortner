class UrlsController < ApplicationController
	def new
		@url = Url.new
	end

	def create
		if (Url.where(longurl: params[:url][:longurl]).first)
			@url = Url.where(longurl: params[:url][:longurl]).first
			redirect_to @url
		else
			@url = Url.new(url_params)
			puts params[:longurl]
			@url.mdsum = UrlsHelper.mdvalue(params[:url][:longurl])
			@url.shorturl = UrlsHelper.conversion(params[:url][:domain],@url.mdsum)
			if @url.save
				redirect_to @url
			else
				render 'new'
			end	
		end
	end

	def show
    	@url = Url.find(params[:id])
  	end

	def Shorturl
		puts "enter shorturl"
		if(Url.where(shorturl: params[:url][:shorturl]).first)
			@url = Url.where(shorturl: params[:url][:shorturl]).first
			redirect_to @url
		else
			render json: {'msg' => 'Invalid shorturl'}
		end 
	end

	private
		def url_params
			params.require(:url).permit(:longurl, :domain, :shorturl)
		end
end
