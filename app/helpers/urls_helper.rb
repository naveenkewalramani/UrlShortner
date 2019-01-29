module UrlsHelper
	
	#Calculate the ascii value of url
	def self.AsciiValue(url)
		ascii_value = 0;
		url.each_char {|url| ascii_value += url.ord}
		return ascii_value
	end

	#Calculate the suffix for  the shorturl
	def self.suffix(longurl,flag)
		ascii_value = AsciiValue(longurl)
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

	#Calculate the domain for shorturl
	def self.domain(domain)
		ascii_value = AsciiValue(domain)
		shorturl="http://"
		map_hash = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" #base(52)
		while ascii_value!=0
			shorturl += map_hash[ascii_value % 52]
			ascii_value = ascii_value /10
		end
		shorturl += '/'
		
		return shorturl
	end

end
