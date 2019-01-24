module UrlsHelper
	def self.mdvalue(value)
		mdsum = 0;
		value.each_char {|x| mdsum+=x.ord}
		return mdsum
	end
	def self.conversion(value1,value2)
		value1=mdvalue(value1)
		shorturl="www."
		map1 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" #base(52)
		map2 = "ABCDEFGHIJKLMNO%PQRSTUVWXYZ0123&456789abcdefghi$jklmnopqrstuvwx*yz" #base(66)
		while value1!=0
			shorturl += map1[value1%52]
			value1=value1/10
		end
		shorturl+='/'
		while value2!=0
			shorturl += map2[value2%66]
			value2=value2/10
		end
		return shorturl
	end
end
