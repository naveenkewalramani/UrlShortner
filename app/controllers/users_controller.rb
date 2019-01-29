class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def login
    @user = User.new
  end

  #FUNCTION FOR SIGNUP
  def signup
    flash[:notice] = ""
    if (User.where(email: params[:user][:email]).first)
      flash[:notice] = "User Already Exist"
      render 'new'
    elsif(User.where(username: params[:user][:username]).first)
      flash[:notice] = "Username Already Exist"
      render 'new'
    else
      @user = User.create_user(user_params)
      if @user !=nil
        set_session
      else
        redirect_to user_new_path  
      end
    end
  end

  #FUNCTION FOR LOGOUT
  def logout
    session[:id]=nil
    session[:username]=nil
    session[:authenticate]=false
    session[:expire_at]=nil
    flash[:notice] = "Logged out"
    @user = User.new
    render 'login'
  end

  #FUNCTION FOR NEW LOGIN 
  def login_check
    flash[:notice] = ""
     @user = User.where(email: params[:user][:email], password: UsersHelper.password_convert(params[:user][:password])).first
    if (@user!=nil)
      set_session
    else
      flash[:notice] = "Invalid Email or Password"
      redirect_to user_login_path
    end
  end

  #Set session
  def set_session
    session[:id]=@user[:id]
    session[:username]=@user[:username]
    session[:authenticate] = true
    session[:expires_at] = Time.current + 20.minutes
    redirect_to new_url_path #redirect to the url page
  end

  private
    def user_params
      params.require(:user).permit(:username , :email, :password)
    end
end
