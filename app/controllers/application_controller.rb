class ApplicationController < ActionController::Base
	protect_from_forgery
	before_action :check_all
	def check_all
	
		if(session[:expires_at]!=nil)
			if(session[:expires_at] < Time.current)
				session[:username]=nil
				session[:authenticate]=false
			end
		end
	end
end
