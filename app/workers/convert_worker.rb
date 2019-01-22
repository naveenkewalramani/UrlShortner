class ConvertWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :count_queue
  def perform(*args)
  	puts Url.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count
  end
end
