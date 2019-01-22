class Urlreport < ApplicationRecord
	def up()
		@counter = Urlreport.where(date: Date.current).first
		if(@counter==nil)
			@counter=Urlreport.new()
			@counter.date = Date.current
			@counter.count=value
			@couter.save
		else
			@counter.count=value
			@counter.save
		end
	end
end
