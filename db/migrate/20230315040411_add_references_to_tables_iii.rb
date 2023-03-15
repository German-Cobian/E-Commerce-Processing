class AddReferencesToTablesIii < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :disbursement, index: true
  end
end
