class UsersController < ApplicationController

  skip_before_action :check_session, only: [:login, :new, :login_check]

=begin
  **Request Type:** GET
  **Routes:** user_new_path
  **URI Pattern:** /users/new
  **Description:** Create a new instance of user object  in order for singup page rendering 
=end
  def new
    @user = User.new
  end


=begin
  **Request Type:** GET
  **Routes:** user_login_path
  **URI Pattern:** /user/log
  **Description:** Create a new instance of user object in order for login page rendering 
=end
  def login
    @user = User.new
  end


=begin
  **Request Type:** POST
  **Routes:** users_signup_path
  **URI Pattern:** /users/signup
  **Params:** username, email, passwords name, password_confirmation
  **Description:** This action searches the database first with email and than with username in order to get whether the 
  username or email is already present or not.If present it will display a message to the user whether the 
  "User already exist" or "Username already taken ".If none of the above two happens ,it will call a create_user function
  defined in user model.Input to the method is username,password and email.If the model method successfully saves the user 
  it will set session via set_session action and than redirect it to the new_url_path.If noty saved it will redirect it 
  to signup page again   
=end
  def signup
    @user = User.new
    if (User.where(email: params[:user][:email]).first)
      flash[:notice] = "User Already Exist"
      render 'new'
    elsif(User.where(username: params[:user][:username]).first)
      flash[:notice] = "Username Already Taken"
      render 'new'
    else
      @user = @user.create_user(user_params)
      if @user !=nil
        set_session
      else
        redirect_to user_new_path  
      end
    end
  end


=begin
  **Request Type: POST
  **Route Path: users_login
  **URI Pattern: /users/login
  **Params:** emailid,password 
  **Description:** This action take email and password as input.If the email and password matches the entry in the
   database.If the entry does not matches it means either the user is not logged in or the email/password is not 
   correct.If entry matches it will call set_session action.
=end
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


=begin 
  **Description:** This will set the session according to the current user with session expiry time of 20 minutes
=end
  def set_session
    session[:id]=@user[:id]
    session[:username]=@user[:username]
    session[:authenticate] = true
    session[:expires_at] = Time.current + 20.minutes
    redirect_to new_url_path #redirect to the url page
  end
  
=begin
  **Request Type:** GET
  **Routes:** urls_path
  **URI pattern:**/urls
  **Description:** Indexes all the records in the url table and show their field on index.html.erb view page.
=end 
  def index
    @user = User.all.order("id ASC")
  end
=begin
  **Request Type:** GET
  **Route Path:** user_logout
  **URI Pattern:** /user/logout
  **Description:** This action will reset the session and render the login page again
=end
  def logout
    session[:id]=nil
    session[:username]=nil
    session[:authenticate]=false
    session[:expire_at]=nil
    flash[:notice] = "Logged out"
    @user = User.new
    render 'login'
  end

  

  private
  def user_params
    params.require(:user).permit(:username , :email, :password)
  end
end
