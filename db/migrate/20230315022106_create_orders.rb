class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.decimal :amount
      t.timestamp :completed_at

      t.timestamps
    end
  end
end
