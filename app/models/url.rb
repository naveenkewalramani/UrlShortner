class Url < ApplicationRecord
	validates :longurl, :presence => true
	validates_format_of :longurl, with: /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/
	after_create :background_process
		def background_process
			 ConvertWorker.perform_async
	 	end
	def self.CreateLongUrl(webparams)  #Create longurl from short url
		@url  = Url.new(webparams)
		@url.suffix= UrlsHelper.suffix(webparams[:longurl])
		@url.shorturl = UrlsHelper.domain(webparams[:domain]) + @url.suffix
		if @url.save
			return @url
		else
			return nil
		end
	end 
	def self.FindLong(longurl) #Search long url in DB
		return Url.where(longurl: longurl).first
	end
	def self.FindShort(shorturl)
		return  Rails.cache.fetch("#{shorturl}", expires_in: 15.minutes) do
					Url.where(shorturl: shorturl).first
				end
	end
	def self.FindSuffix(suffix)
		return  Rails.cache.fetch("#{suffix}", expires_in: 15.minutes) do
					Url.where(suffix: suffix).first
				end
	end
end

	
