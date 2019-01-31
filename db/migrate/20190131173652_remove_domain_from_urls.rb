class RemoveDomainFromUrls < ActiveRecord::Migration[5.2]
  def change
    remove_column :urls, :domain, :string
  end
end
