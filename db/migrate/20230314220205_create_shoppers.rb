class CreateShoppers < ActiveRecord::Migration[7.0]
  def change
    create_table :shoppers do |t|
      t.string :name
      t.string :email
      t.string :nif

      t.timestamps
    end
  end
end
