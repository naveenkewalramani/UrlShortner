class AddIndexToUrls < ActiveRecord::Migration[5.2]
  def change
    add_index :urls, :longurl
    add_index :urls, :shorturl
  end
end
