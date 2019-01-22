class UsersController < ApplicationController

  def new
    @user = User.new
  end

   def login
    @user = User.new
  end

  def signup
    flash[:notice] = ""
    @user = User.new(user_params)
    @user.password = UsersHelper.password_convert(params[:user][:password])
    if (User.where(email: params[:user][:email]).first)
      flash[:notice] = "User Already Exist"
      render 'new'
    elsif(User.where(username: params[:user][:username]).first)
      flash[:notice] = "Username Already Exist"
      render 'new'
    else
      if @user.save
        session[:id]=@user[:id]
        session[:authenticate] = true
        session[:expires_at] = Time.current + 10.seconds
        redirect_to new_url_path #redirect to the url page
      else
        flash[:notice] = "User Already Exist"
        render 'new'
      end
    end
  end

  def logout
    session[:username]=nil
    session[:authenticate]=false
    flash[:success] = "Logged out"
    @user = User.new()
    render 'login'
  end

  def login_new
    flash[:notice] = ""
     @user = User.where(email: params[:user][:email], password: UsersHelper.password_convert(params[:user][:password])).first
    if (@user!=nil)
      session[:id]=@user[:id]
      session[:authenticate] = true
      session[:expires_at] = Time.current + 10.seconds
      redirect_to new_url_path
    else
      @user = User.new(user_params)
      flash[:notice] = "username/password/email invalid"
      render 'login'
    end
  end

  def show
    @user = User.find(params[:id])
  end
  private
    def user_params
      params.require(:user).permit(:username , :email, :password)
    end
end
