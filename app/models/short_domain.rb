class ShortDomain < ApplicationRecord
  validates :domain, presence: true , :length => { :in => 3..1000 }
  validates :prefix, presence: true , :length => { :in => 3..1000 }

  #search the short_domain table for input domain value
  def self.find_domain(domain)
    return ShortDomain.where(domain: domain).first
  end
end
