class ShortDomain < ApplicationRecord
  validates :domain, presence: true , :length => { :in => 3..1000 }, uniqueness: true
  validates :prefix, presence: true , :length => { :in => 3..1000 }, uniqueness: true

  #search the short_domain table for input domain value
  def find_short_domain(domain)
    return ShortDomain.where(domain: domain).first
  end
end
