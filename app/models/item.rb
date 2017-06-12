class Item < ApplicationRecord
  belongs_to :product
  belongs_to :driver

  validates :product, presence: true, uniqueness: {scope: :driver}, allow_nil: false

  before_create :check_duplicate
  after_create :update_quantity

  def check_duplicate
  	items = Item.exists?(product_id: self.product_id, driver_id: self.driver_id)
  	if items
  		errors[:base] << "Add your validation message here"
		  return false
  	else
  		return true
  	end
  end

  def update_quantity
		if product.quantity > 0
			product.quantity =  product.quantity - self.quantity
			product.save
		end
	end
end
