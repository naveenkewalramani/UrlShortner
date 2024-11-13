require 'domainatrix'
class UrlsController < ApplicationController

=begin
  **Description:** This action will check whether the user is already logged in or not .If not it will 
  redirect it to the user_login_path.If logged in it will create a new instance of user object and 
  render the new.html.erb file
=end
  def new
    @url = Url.new
  end

  
=begin
  **Common Name:** Create shorturl from the input longurl and domain
  **End points:** Other services
  **Request Type:** POST
  **Route:** urls_long_path
  **url:**  URI("http://localhost:3000/urls/long")
  **Paramas:** { "longurl" : " ","domain"  : " "}
  **Cookies:** {
    Name : _project_intern_session
    Value : 
    Domain : localhost
    HttpOnly : True
    Secure : false
  }
  **Content-Type:** application/json; charset=utf-8
  **Input Type:** JSON
  **Input Fields:** longurl,domain 
  **Output Type:** JSON
  **Output Fields:** status, shorturl
  **Host:** localhost:3000
  **Cache-Control:** no-cache
  **Custom Status Messages:** {
    a)Message : "already_exist"
    Status  : 200 OK
    Description : Since the input longurl is already existed in the database,it will just find the shorturl correponding to that longurl in the database and return that shorturl along with above mentioned message.

    b)Message  : "new created shorturl"
    Status   :  200 OK
    Description : If the input longurl is not already present in the database,and new shorturl is created correponding to that longurl and domain.It is than saved in the database and return the newly generated shorturl alongwith the above message.

    c)Message : "error occured"
    Status : 404 not-dound
    Description : If the input url is not according to the validations mentioned in the url model ,than an error message will be displayed to the user as mentioned above

    d)Status : 500 Internal server error
    Description : If the longurl is not defined in the input params

    e)Message : "Short Domain not found,please add short domain" 
    Status : 404 not-found
    Description : if domain entered by user in not in shortdomain table

    f)Message : "Domain Name does not matched" 
    Status : 404 not-found
    Description : if domain entered by user in not match longurl domain
  }   
=end
  
  def create_shorturl
    # respond_to do |format|
    #   format.json{
    #     url=Url.new
    #     response = url.check_params(params[:longurl])
    #     puts response
    #     if response!=true
    #       render json: { 'message' => "Invalid longurl value or Domain not registered"}
    #     else
    #       if url.find_long(params[:longurl]) != nil
    #         render json: { 'message' => 'longurl already exist', 'shorturl' => url.shorturl }
    #       else       
    #         url=Url.new
    #         if url.create_short_url(url_params) == nil
    #           render json: { 'message' => 'error occured' }, status: :not_found
    #         else
    #           render json: { 'message' => 'new created shorturl', 'shorturl' => url.shorturl }
    #         end
    #       end
    #     end
    #   }   
    #   format.html{
    @url=Url.new
    response = @url.check_params(params[:url][:longurl])
    if response != true
      flash[:notice]="Invalid longurl value or Domain not registered"
      render 'new'
    else
      if @url.find_long(params[:url][:longurl]) != nil
        redirect_to @url.find_long(params[:url][:longurl])
      else
        @url=@url.create_short_url(url_params)
        if @url != nil
          render 'show' 
        else
          flash[:notice] = "Invalid long Url"
          render 'new'  
        end
      end
    end
  end

=begin
  **Common Name:** Show the url by search it in database via params[:id]
  **Request Type:** GET
  **Routes:** url_path
  **Description:** Check the authentication session and if logged in,it will display the longurl,shorturl,domain and suffix corresponding to the url
=end 
  def show
    @url = Url.find(params[:id])
  end
  
=begin
  **Common Name:**Search for longurl from input shorturl
  **End points:** Other services
  **Request Type** : GET
  **Routes** : url_long_path
  **url:** URI("http://localhost:3000/url/long?shorturl=")
  **Params:** KEY->shorturl , VALUE-> '' , DESCRIPTION-> 'ShortUrl Input to get longurl in return'
  **Cookies:**{
    Name : _project_intern_session
    Value : 
    Domain : localhost
    HttpOnly : True
    Secure : false
  }
  **Content-Type:** application/json; charset=utf-8
  **Output Type:** JSON
  **Output Fields:** status,longurl
  **Host:** localhost:3000
  **Cache-Control:**  no-cache
  **Custom Status Messages:**{
    a)Message : "longurl corresponding to shorturl is found"
    Status  : 404 not-found
    Description : Since the input shorturl is already existed in the database,it will just find the longurl correponding to that shorturl in the database and return that longurl along with above mentioned message.

    b)Message  : "Invalid shorturl"
    Status   :  200 OK
    Description : If the input shorturl is not already present in the database,it will return the above message

    c)Status : 404 not-found
    Description : If the shorturl key is not mentioned in the input params
  }
=end
  def search_longurl
    # respond_to do |format|
    #   format.json{
    #     url=Url.new
    #     if(params[:shorturl]==nil)
    #       render json: { 'message' => 'Input Shorturl is Empty' }, status: :not_found 
    #     else
    #       if(params[:shorturl][0..6]!="http://")
    #         url = url.find_suffix(params[:shorturl])
    #       else
    #         url = url.find_short(params[:shorturl])
    #       end
    #       if url!=nil
    #         render json: { 'message' => 'longurl corresponding to shorturl is found', 'longurl' => url.longurl }
    #       else
    #         render json: { 'message' => 'Invalid shorturl' } ,status: :not_found    
    #       end
    #     end
    #   }
    #   format.html{
    @url=Url.new
    if(params[:url][:shorturl]==nil)
      flash[:notice] = "Input Shorturl is Empty"
      redirect_to new_url_path
    else
      if(params[:url][:shorturl][0..6]!="http://")
        @url = @url.find_suffix(params[:url][:shorturl])
      else
        @url = @url.find_short(params[:url][:shorturl])
      end
      if @url!=nil
        redirect_to @url
      else
        @url=Url.new
        flash[:notice] = "Invalid Short Url"
        redirect_to new_url_path
      end
    end 
  end

  private
    def url_params
      params.require(:url).permit(:longurl, :domain, :shorturl )
    end
end
