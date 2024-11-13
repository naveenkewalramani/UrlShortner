class AddIndexToShortDomain < ActiveRecord::Migration[5.2]
  def change
    add_index :short_domains, :domain
  end
end
