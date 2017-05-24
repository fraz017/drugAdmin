class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.integer :quantity, default: 0
      t.string :name
      t.text :description
      t.text :ingredients
      t.float :price

      t.timestamps
    end
  end
end
