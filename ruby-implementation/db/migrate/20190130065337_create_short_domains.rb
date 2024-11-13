class CreateShortDomains < ActiveRecord::Migration[5.2]
  def change
    create_table :short_domains do |t|
      t.string :domain
      t.string :prefix
      t.timestamps
    end
  end
end
