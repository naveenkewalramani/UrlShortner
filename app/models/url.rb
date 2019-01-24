class Url < ApplicationRecord
	validates :longurl, :presence => true
	validates_format_of :longurl, with: /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/
	after_create :background_process
		def background_process
			 ConvertWorker.perform_async
	 	end
	def self.CreateLongUrl(webparams)
		@url  = Url.new(webparams)
		@url.suffix= UrlsHelper.suffix(webparams[:longurl])
		@url.shorturl = UrlsHelper.domain(webparams[:domain]) + @url.suffix
		if @url.save
			return @url
		else
			return nil
		end
	end 
end

	
