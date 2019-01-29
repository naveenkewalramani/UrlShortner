class UrlreportsController < ApplicationController
	#Index Order all entries in urlreport DB
	def index
    @urlreport = Urlreport.all.order("id ASC")
  end
end