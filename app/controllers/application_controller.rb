class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :check_session
  #This function checks whether session is set or not 
  def check_session
    if(session[:expires_at]!=nil)
      if(session[:expires_at] < Time.current)
        session[:username]=nil
	      session[:authenticate]=false
        #redirect_to user_login_path
      end
    end
  end
end
