class UsersController < ApplicationController

  def new
    @user = User.new
  end

   def login
    @user = User.new
  end

  def Signup
    @user = User.new(user_params)
    if (User.where(email: params[:user][:email]).first)
      render json: {'msg' => 'user already exist'}
    elsif(User.where(username: params[:user][:username]).first)
      render json: {'msg' => 'username already exist'}
    else
      if @user.save
        redirect_to new_url_path #redirect to the url page
      else
        render json: {'msg' => 'form invalid'}
      end
    end
  end

 
  def Login
    puts "login emnter"
    if (User.where(email: params[:user][:email], username: params[:user][:username]).first)
      @user = User.where(email: params[:user][:email], username: params[:user][:username]).first
      redirect_to new_url_path
    else
      render json: {'msg' => 'username/password/email invalid'}
    end
  end

  def show
    @user = User.find(params[:id])
  end
  private
    def user_params
      params.require(:user).permit(:email, :password, :username)
    end
end
