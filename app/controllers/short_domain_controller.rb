class ShortDomainController < ApplicationController

=begin
  **Request Type:**GET
  **URI pattern :**/short_domain/mew
  **Routes:**new_short_domain
  **Description:**Create a new instance of short domain
=end
  def new
    @short_domain = ShortDomain.new
  end


=begin
  **Request Type:**POST
  **URI pattern :**/short_domain/create
  **Routes:**short_domain_create
  **Description:** This action searches for the existing short domain(if any).If not creates 
  a new shortdomain will be created and saved.
=end
  def create_short_domain
    @short_domain=ShortDomain.new
    @short_domain = @short_domain.find_short_domain(params[:short_domain][:domain])
    if @short_domain!=nil
      flash[:message] ="Short Domain already exist"
    else
      @short_domain = ShortDomain.new(domain_params)
      if @short_domain.save
        flash[:notice] = "Domain added successfully"
        render 'new'
      else
        flash[:notice] =  "Error in creating new domain"
      end 
    end
  end


=begin
  **Request Type:**GET
  **URI pattern :**/short_domain
  **Routes:** short_domain_index_path
  **Description:**This actions indexex all the rows of the short_domain table and order them in ascending order
=end
  def index
    @short_domain = ShortDomain.all.order("id ASC")
  end
  private
    def domain_params
      params.require(:short_domain).permit(:prefix, :domain)
    end
end
