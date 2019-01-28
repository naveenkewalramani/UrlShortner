class User < ApplicationRecord
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  validates :password, :confirmation => true 
  validates_length_of :password, :in => 6..200, :on => :create

  def self.CreateUser(user_params)
  	@user = User.new(user_params)
    @user.password = UsersHelper.password_convert(user_params[:password])
    if @user.save
    	return @user
    else
    	return nil
    end
  end
end
