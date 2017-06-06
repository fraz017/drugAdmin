class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.references :driver, foreign_key: true
      t.string :order_number
      t.float :total
      t.integer :status_cd, default: 0

      t.timestamps
    end
  end
end
