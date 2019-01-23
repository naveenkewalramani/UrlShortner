class Url < ApplicationRecord
	validates :longurl, :presence => true
	validates_format_of :longurl, with: /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/
	after_create :background_process
		def background_process
			 ConvertWorker.perform_async
	 	end
end


