class UrlsController < ApplicationController
	def new
		if(session[:authenticate] == true)
			
			@url = Url.new
		else
			redirect_to user_login_path
		end
	end

	def create
		if(session[:authenticate] == true)
			@url = Url.where(longurl: params[:url][:longurl]).first
			#@url = Url.where(longurl: params[:url][:longurl], domain: params[:url][:domain]).first
			if @url!=nil
				redirect_to @url
			else
				@url = Url.new(url_params)
				@url.mdsum = UrlsHelper.mdvalue(params[:url][:longurl])
				@url.shorturl = UrlsHelper.conversion(params[:url][:domain],@url.mdsum)
				if @url.save
					redirect_to @url
				else
					render 'new'
				end	
			end
		else
			redirect_to user_login_path
		end
	end

	def show
		if(session[:authenticate] == true)
    		@url = Url.find(params[:id])
    	else
    		redirect_to user_login_path
    	end
  	end

	def Shorturl
		if(session[:authenticate] == true)
			if(params[:url][:shorturl][0..3]!="www.")
				params[:url][:shorturl]="www.nav.com/"+params[:url][:shorturl]
			end
			@url = Rails.cache.fetch("#{params[:url][:shorturl]}", expires_in: 15.minutes) do
				Url.where(shorturl: params[:url][:shorturl]).first
			end
			if @url!=nil
				redirect_to @url
			else
				flash[:notice] = "Not a valid url"
				redirect_to new_url_path
			end 
		else
			redirect_to user_login_path
		end
	end

	private
		def url_params
			params.require(:url).permit(:longurl, :domain, :shorturl)
		end
end
