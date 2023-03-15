class AddReferencesToTables < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :merchant, foreign_key: true, null: false, index: true
    add_reference :orders, :shopper, foreign_key: true, index: true
  end
end
