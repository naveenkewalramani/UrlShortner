class Urlreport < ApplicationRecord
	validates :date, :presence => true, :uniqueness => true
  validates :count, :presence => true
end
