class UrlreportsController < ApplicationController
  def new
    @urlreport = Urlreport.new
  end
=begin
  **Request Type:** GET
  **Route Path:** urlreport
  **Description:** Indexes all the records in the urlreports table and show their field on index.html.erb view page.
=end
  def index
    @urlreport = Urlreport.where(date: params[:urlreport][:date])
    if @urlreport == nil
      @url=Urlreport.new
    else
      render 'index'
    end
  end
end
