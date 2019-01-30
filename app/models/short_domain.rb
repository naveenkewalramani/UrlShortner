class ShortDomain < ApplicationRecord
  validates :domain, presence: true , :length => { :in => 3..1000 }
  validates :prefix, presence: true , :length => { :in => 3..1000 }
  def self.find_domain(domain)
    return ShortDomain.where(domain: domain).first
  end
end
