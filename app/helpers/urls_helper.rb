module UrlsHelper
	def self.mdvalue(input)
		mdsum = 0;
		input.each_char {|x| mdsum+=x.ord}
		return mdsum
	end
	def self.suffix(input)
		mdsum = mdvalue(input)
		output = ""
		map = "ABCDEFGHIJKLMNO%PQRSTUVWXYZ0123&456789abcdefghi$jklmnopqrstuvwx*yz" #base(66)
		while mdsum!=0
			output += map[mdsum%66]
			mdsum=mdsum/10
		end
		return output
	end
	def self.domain(input)
		mdsum=mdvalue(input)
		shorturl="www."
		map = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" #base(52)
		while mdsum!=0
			shorturl += map[mdsum%52]
			mdsum=mdsum/10
		end
		shorturl+='/'
		
		return shorturl
	end
end
