require 'elasticsearch/model'
class Url < ApplicationRecord
	
	#Include Library
	include Elasticsearch::Model
 	include Elasticsearch::Model::Callbacks

 	index_name('urls')

 	#Validations of url
	validates :longurl, :presence => true
	validates_format_of :longurl, with: /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/
	
	after_create :background_process
	def background_process
		ConvertWorker.perform_async
	end

	#Create longurl from short url
	def self.CreateLongUrl(url_params)  
		@url  = Url.new(url_params)
		@url.suffix= UrlsHelper.suffix(url_params[:longurl],0)
		while Unique(@url.suffix) == false
			@url.suffix = Urls.Helper.suffix(url_params[:longurl],1)
		end
		@url.shorturl = UrlsHelper.domain(url_params[:domain]) + @url.suffix
		if @url.save
			return @url
		else
			return nil
		end
	end

	#Search Long Url in DB
	def self.FindLong(longurl) 
		return Url.where(longurl: longurl).first
	end

	#Redis search shorturl
	def self.FindShort(shorturl)        
		return  Rails.cache.fetch("#{shorturl}", expires_in: 15.minutes) do
				Url.where(shorturl: shorturl).first
			end
	end

	#Redis search suffix
	def self.FindSuffix(suffix)          
		return  Rails.cache.fetch("#{suffix}", expires_in: 15.minutes) do
				Url.where(suffix: suffix).first
			end
	end

	#Find Unique Suffix
	def self.Unique(suffix)         
		@check = Url.where(suffix: suffix).first
		if @check == nil
			return true
		else
			return false
		end
	end
end

	
