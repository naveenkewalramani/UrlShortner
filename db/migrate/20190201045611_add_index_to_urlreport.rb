class AddIndexToUrlreport < ActiveRecord::Migration[5.2]
  def change
    add_index :urlreports, :date
  end
end
