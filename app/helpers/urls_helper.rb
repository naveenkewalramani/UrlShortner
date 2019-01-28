module UrlsHelper
	def self.mdvalue(input)
		ascii = 0;
		input.each_char {|x| ascii+=x.ord}
		return ascii
	end
	def self.suffix(input,flag)
		ascii = mdvalue(input)
		if(flag == 1)
			ascii = ascii + rand(100..1000)
		end
		output = ""
		map = "ABCDEFGHIJKLMNO%PQRSTUVWXYZ0123&456789abcdefghi$jklmnopqrstuvwx*yz" #base(66)
		while ascii!=0
			output += map[ascii%66]
			ascii=ascii/10
		end
		return output
	end
	def self.domain(input)
		ascii=mdvalue(input)
		shorturl="http://"
		map = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" #base(52)
		while ascii!=0
			shorturl += map[ascii%52]
			ascii=ascii/10
		end
		shorturl+='/'
		
		return shorturl
	end
end
