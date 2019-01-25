class UrlsController < ApplicationController
	def new
		if(session[:authenticate] == true)
			@url = Url.new
		else
			redirect_to user_login_path
		end
	end

	def create
		respond_to do |format|
			format.json{
				@url = Url.FindLong(params[:longurl])
				if @url!=nil
					render json: { 'status' => 'already_exist', 'shorturl' =>	@url.shorturl }
				else
					@url = Url.CreateLongUrl(url_params)
					if @url!=nil
						render json: { 'status' => 'new_created', 'shorturl' => @url.shorturl }
					else 
						render json: { 'status' => 'error_occured' }
					end
				end
			}	
			format.html{
				if(session[:authenticate] == true)
					@url = Url.FindLong(params[:url][:longurl])
					if @url!=nil
						redirect_to @url
					else
						@url = Url.CreateLongUrl(url_params)
						if @url!=nil
							redirect_to @url
						else
							@url = Url.new
							flash[:notice] = "Invalid long url"
							render 'new'
						end
					end
				else
					redirect_to user_login_path
				end
			}
			
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
			long 
		else
			redirect_to user_login_path
		end
	end

	def long
		respond_to do |format|
			format.json{
				if(params[:shorturl][0..3]!="www.")
					@url = Url.FindSuffix(params[:shorturl])
				else
					@url = Url.FindShort(params[:shorturl])
				end
				if @url!=nil
					render json: { 'status' => 'already_exist', 'longurl' => @url.longurl }
				else
					render json: { 'status' => 'invalid_shorturl' }		
				end
			}
			format.html{
				if(params[:shorturl][0..3]!="www.")
					@url = Url.FindSuffix(params[:url][:shorturl])
				else
					@url = Url.FindShort(params[:url][:shorturl])
				end
				if @url!=nil
					redirect_to @url
				else
					flash[:notice] = "Not a valid url"
					redirect_to new_url_path
				end 
			}
		end
	end

	private
		def url_params
			params.require(:url).permit( :utf8, :longurl, :domain, :shorturl )
		end
end
