class CreateUrlreports < ActiveRecord::Migration[5.2]
  def change
    create_table :urlreports do |t|
      t.integer :count
      t.string :date
    end
  end
end
