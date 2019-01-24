module UrlsHelper
	def self.mdvalue(value)
		mdsum = 0;
		value.each_char {|x| mdsum+=x.ord}
		return mdsum
	end
	def self.conversion(value1,value2)
		shorturl = "www.nav.com/"
		map = "ABCDEFGHIJKLMNO%PQRSTUVWXYZ0123&456789abcdefghi$jklmnopqrstuvwx*yz"
		while value2!=0
			shorturl += map[value2%67]
			value2=value2/10
		end
		return shorturl
	end
end
