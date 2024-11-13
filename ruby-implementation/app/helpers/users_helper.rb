module UsersHelper
	def self.password_convert(password)
		Digest::MD5.hexdigest password
	end
end