class UrlsController < ApplicationController
	def new
		@url = Url.new
	end

	def create
		if Url.where(longurl: params[:longurl]).first == nil
			@url = Url.new(url_params)
			@url.mdsum = 0
			@url.longurl.each_char {|x| @url.mdsum += x.ord}
			@url.shorturl = @url.domain + (@url.mdsum%67).to_s
			if @url.save
				redirect_to @url
			else
				render 'new'
			end
		else
			#render json: {'status' => 'already_exist'}

			@url = Url.where(longurl: params[:url][:longurl]).first
			print @url.as_json
			redirect_to @url		
		end
	end

	def show
    	@url = Url.find(params[:id])
  	end

	def show_long_url
		if Url.where(shorturl: params[:shorturl]).first == nil
			render json: {'status' => 'not found'}
		else
			@row = Url.where(shorturl: params[:shorturl]).first
			redirect_to @row
		end
	end

	private
		def url_params
			params.require(:url).permit(:longurl, :domain)
		end
end
