class ShortDomainController < ApplicationController
  def new
    @short_domain = ShortDomain.new
  end
  def create_short_domain
    @short_domain = ShortDomain.find_domain(params[:short_domain][:domain])
    if @short_domain!=nil
      flash[:message] ="short domain already exist"
    else
      @short_domain = ShortDomain.new(domain_params)
      @short_domain.save
      flash[:notice] = "domain added successfully"
      render 'new'
    end
  end
  def index
    @short_domain = ShortDomain.all.order("id ASC")
  end
  private
    def domain_params
      params.require(:short_domain).permit(:prefix, :domain)
    end
end
