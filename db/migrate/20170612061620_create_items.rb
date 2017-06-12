class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.references :product, foreign_key: true
      t.references :driver, foreign_key: true
      t.integer :quantity, default: 0

      t.timestamps
    end
    # add_index :items, [ :product_id, :driver_id ], :unique => true
  end
end
