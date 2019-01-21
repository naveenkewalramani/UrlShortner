class UrlsController < ApplicationController
	def new
		@url = Url.new
	end

	def create
		@url = Url.where(longurl: params[:url][:longurl]).first
		#@url = Url.where(longurl: params[:url][:longurl], domain: params[:url][:domain]).first
		if @url!=nil
			redirect_to @url
		else
			@url = Url.new(url_params)
			@url.mdsum = UrlsHelper.mdvalue(params[:url][:longurl])
			@url.shorturl = UrlsHelper.conversion(params[:url][:domain],@url.mdsum)
			if @url.save
				flash[:success] = "Welcome to the Sample App!"
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
		@url = Rails.cache.fetch("#{params[:url][:shorturl]}", expires_in: 12.hours) do
			Url.where(shorturl: params[:url][:shorturl]).first
		end
		if @url!=nil
			redirect_to @url
		else
			render json: {'msg' => 'Short url not present in Database'}
		end 
	end

	private
		def url_params
			params.require(:url).permit(:longurl, :domain, :shorturl)
		end
end
