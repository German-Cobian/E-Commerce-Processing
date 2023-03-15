class CreateDisbursements < ActiveRecord::Migration[7.0]
  def change
    create_table :disbursements do |t|
      t.decimal :amount
      t.integer :week
      t.integer :year

      t.timestamps
    end
  end
end
