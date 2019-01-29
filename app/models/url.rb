require 'elasticsearch/model'
class Url < ApplicationRecord
  
  #Elastic Search
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  searchkick
  index_name('urls')

  #Validations of url
  validates :longurl, :presence => true
  validates_format_of :longurl, with: /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/
  
  #Sidekiq 
  after_create :background_process
  def background_process
    ConvertWorker.perform_async
  end

  #Create longurl from short url
  def self.create_longurl(url_params)  
    url  = Url.new(url_params)
    url.suffix= UrlsHelper.suffix(url_params[:longurl],0)
    while unique(url.suffix) == false
      url.suffix = UrlsHelper.suffix(url_params[:longurl],1)
    end
    url.shorturl = UrlsHelper.domain(url_params[:domain]) + url.suffix
    if url.save
      return url
    else
      return nil
    end
  end

  #Search Long Url in DB
  def self.find_long(longurl) 
     Url.where(longurl: longurl).first
  end

  #Redis search shorturl
  def self.find_short(shorturl)        
    Rails.cache.fetch("#{shorturl}", expires_in: 100.hours) do
        Url.where(shorturl: shorturl).first
    end
  end

  #Redis search suffix
  def self.find_suffix(suffix)          
    Rails.cache.fetch("#{suffix}", expires_in: 100.hours) do
      Url.where(suffix: suffix).first
    end
  end

  #Find Unique Suffix
  def self.unique(suffix)         
    check = Url.where(suffix: suffix).first
    if check == nil
      return true
    else
      return false
    end
  end
end

  
