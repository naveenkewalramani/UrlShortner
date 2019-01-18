class Url < ApplicationRecord
	validates :longurl, :presence => true, :uniqueness => true
end
