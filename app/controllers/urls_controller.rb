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
			if @url!=nil
				redirect_to @url
			else
				@url = Url.new(web_params)
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

	def short
		@url = Url.where(longurl: params[:longurl]).first
		if @url!=nil
			render json: { 'status' => 'already_exist' , 'shorturl' =>	@url.shorturl }
		else
			@url = Url.new(web_params)
			@url.mdsum = UrlsHelper.mdvalue(params[:longurl])
			@url.shorturl = UrlsHelper.conversion(params[:domain],@url.mdsum)
			if @url.save
				render json: { 'status' => 'new_created' , 'shorturl' => @url.shorturl }
			else 
				render json: { 'status' => 'error_occured' }
			end
		end
	end

	def long
		if(params[:shorturl][0..3]!="www.")
				params[:shorturl]="www.nav.com/"+params[:shorturl]
		end
		@url = Rails.cache.fetch("#{params[:shorturl]}", expires_in: 15.minutes) do
			Url.where(shorturl: params[:shorturl]).first
		end
		if @url!=nil
			render json: { 'status' => 'already_exist' , 'shorturl' => @url.longurl }
		else
			render json: { 'status' => 'invalid_shorturl' }
		end
	end

	private
		def web_params
			params.require(:url).permit( :utf8, :longurl, :domain, :shorturl )
		end

		def postman_params
			params.permit( :longurl, :domain )
		end

end
