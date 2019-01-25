require 'elasticsearch/model'
class Url < ApplicationRecord
	searchkick
	include Elasticsearch::Model
 	include Elasticsearch::Model::Callbacks
 	index_name('urls')
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
	def self.FindShort(shorturl) #Redis search shorturl
		return  Rails.cache.fetch("#{shorturl}", expires_in: 15.minutes) do
					Url.where(shorturl: shorturl).first
				end
	end
	def self.FindSuffix(suffix) #Redis search suffix url
		return  Rails.cache.fetch("#{suffix}", expires_in: 15.minutes) do
					Url.where(suffix: suffix).first
				end
	end
end

	
