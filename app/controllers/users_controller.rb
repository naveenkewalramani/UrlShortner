class UsersController < ApplicationController

  def new
    @user = User.new
  end

   def login
    @user = User.new
  end

  def signup
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
        redirect_to new_url_path #redirect to the url page
      else
        flash[:notice] = "User Already Exist"
        render 'new'
      end
    end
  end

 
  def login_new
    
    if (User.where(email: params[:user][:email], username: params[:user][:username], password: UsersHelper.password_convert(params[:user][:password])).first)
      @user = User.where(email: params[:user][:email], username: params[:user][:username], password: UsersHelper.password_convert(params[:user][:password])).first
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
