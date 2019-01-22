class Url < ApplicationRecord
	validates :longurl, :presence => true
	validates_format_of :longurl, with: /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/
	after_commit :start_background_processing
		def start_background_processing
			 ConvertWorker.perform_async()
	 	end
end


