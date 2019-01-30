class UrlreportsController < ApplicationController
=begin
	**Request Type:** GET
	**Route Path:** urlreport
	**Description:** Indexes all the records in the urlreports table and show their field on index.html.erb view page.
=end
  def index
    @urlreport = Urlreport.all.order("id ASC")
  end
end