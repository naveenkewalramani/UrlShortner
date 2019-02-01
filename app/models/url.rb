require 'elasticsearch/model'
require 'domainatrix'
class Url < ApplicationRecord
  
  #Elastic Search
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  searchkick
  index_name('urls')

  #Validations of url
  validates :longurl, presence: true , :length => { :in => 3..1000 } , uniqueness: true
  validates_format_of :longurl, with: /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#-?&\/\/=]*)?\z/
  validates :shorturl, presence: true , :length => { :in => 3..1000 } , uniqueness: true
  validates_format_of :shorturl, with: /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#-?&\/\/=]*)?\z/
  
  #mapping for elastic search
  settings index: {
   number_of_shards: 1,
   number_of_replicas: 0,
   analysis: {
      analyzer: {
         pattern: {
            type: 'pattern',
            pattern: "\\s|_|-|\\.",
            lowercase: true
         },
       }
     }
   }do
    mapping do
      indexes :short_url, type: 'text', analyzer: 'english' do
        indexes :keyword, analyzer: 'keyword'
        indexes :pattern, analyzer: 'pattern'
      end
      indexes :long_url, type: 'text', analyzer: 'english' do
        indexes :keyword, analyzer: 'keyword'
        indexes :pattern, analyzer: 'pattern'
      end
    end
  end

  #Sidekiq 
  after_create :background_process
  def background_process
    ConvertWorker.perform_async
  end

  #check all input parameters
  def check_params(longurl)
    if longurl==""
      return false
    else 
      short_domain =  ShortDomain.where(domain: Domainatrix.parse(longurl).domain + '.' + Domainatrix.parse(longurl).public_suffix).first
      if short_domain == nil
        return false
      else
        return true
      end
    end
  end

  #Create shorturl from longurl
  def create_short_url(url_params)  
    url  = Url.new(url_params)
    url.suffix= url.create_suffix(url_params[:longurl],0)
    while url.unique(url.suffix) == false
      url.suffix = url.create_suffix(url_params[:longurl],1)
    end
    domain = Domainatrix.parse(url_params[:longurl]).domain + '.' + Domainatrix.parse(url_params[:longurl]).public_suffix
    short_domain = ShortDomain.where(domain: domain).first[:prefix]
    url.shorturl = "http://" + short_domain +'/'+ url.suffix
    if url.save
      return url
    else
      return nil
    end
  end

  #Search Long Url in DB
  def find_long(longurl) 
     Url.where(longurl: longurl).first
  end

  #Redis search shorturl
  def find_short(shorturl)        
    Rails.cache.fetch("#{shorturl}", expires_in: 100.hours) do
        Url.where(shorturl: shorturl).first
    end
  end

  #Redis search suffix
  def find_suffix(suffix)          
    Rails.cache.fetch("#{suffix}", expires_in: 100.hours) do
      Url.where(suffix: suffix).first
    end
  end

  #Check whether generated suffix is unique or not
  def unique(suffix)         
    check = Url.where(suffix: suffix).first
    if check == nil
      return true
    else
      return false
    end
  end

  #Calculate the ascii value of url
  def ascii_value(url)
    ascii_value = 0;
    url.each_char {|url| ascii_value += url.ord}
    return ascii_value
  end

  #Calculate the suffix for  the shorturl
  def create_suffix(longurl,flag)
    ascii_value = ascii_value(longurl)
    if(flag == 1)
      ascii_value = ascii_value + rand(100..1000)
    end
    suffix = ""
    map_hash = "ABCDEFGHIJKLMNO%PQRSTUVWXYZ0123&456789abcdefghi$jklmnopqrstuvwx*yz" #base(66)
    while ascii_value!=0
      suffix += map_hash[ascii_value % 66]
      ascii_value = ascii_value/10
    end
    return suffix
  end
end

  
