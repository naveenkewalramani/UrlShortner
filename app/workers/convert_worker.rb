class ConvertWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :count_queue
  def perform(*args)
  	@urlreport = Urlreport.where(date: Date.today).first
  	if @urlreport == nil
  		@urlreport = Urlreport.new()
  		@urlreport.date = Date.today
  		@urlreport.count = 1
  		@url.save	
  	else
  		@urlreport.update(count: @urlreport.count+=1)
  	end
  end
end
