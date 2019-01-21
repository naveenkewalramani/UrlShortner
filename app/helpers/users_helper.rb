module UsersHelper
	def self.password_convert(value)
		flag=1
		password  = ""
		mdsum=0
		value.each_char do |x|
			mdsum+=x.ord
			if (flag==1)
				password = password + (x.ord+1).chr + mdsum.to_s
				flag=0
			elsif(flag==0)
				password = password + (x.ord+2).chr 
 				flag=1
			end
		end
		return password
	end
end
