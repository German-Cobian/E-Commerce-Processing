class CreateDisbursements < ActiveRecord::Migration[7.0]
  def change
    create_table :disbursements do |t|
      t.decimal :amount, null: false, default: 0
      t.integer :week, null: false
      t.integer :year, null: false

      t.timestamps
    end
  end
end
