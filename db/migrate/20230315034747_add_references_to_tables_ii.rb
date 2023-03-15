class AddReferencesToTablesIi < ActiveRecord::Migration[7.0]
  def change
    add_reference :disbursements, :merchant, foreign_key: true, null: false, index: true
    add_index :disbursements, %i[merchant_id year week], unique: true
  end
end
