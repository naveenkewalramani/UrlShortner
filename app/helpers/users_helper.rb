module UsersHelper
	def self.password_convert(password)
		flag = 1
		encrypted_password  =  ""
		ascii_value = 0
		password.each_char do |t|
  		ascii_value += t.ord
  		if (!flag.zero?)
  			encrypted_password = encrypted_password + (t.ord+1).chr + ascii_value.to_s
  			flag = 0
  		elsif(flag.zero?)
  			encrypted_password = encrypted_password + (t.ord+2).chr 
   			flag = 1
  		end
	  end
		return encrypted_password
	end
end
