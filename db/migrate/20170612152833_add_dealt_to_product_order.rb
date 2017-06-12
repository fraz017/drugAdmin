class AddDealtToProductOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :product_orders, :dealt, :boolean, default: false
  end
end
