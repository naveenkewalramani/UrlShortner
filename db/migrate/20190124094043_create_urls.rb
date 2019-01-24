class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.string :longurl 
      t.string :shorturl
      t.string :domain
      t.string :suffix
    end
  end
end
