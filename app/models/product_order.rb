class ProductOrder < ApplicationRecord
	BASE_URL = "http://suavistech.com:3001"
  belongs_to :product
  belongs_to :order

  validates :product, presence: true
  # validates :order, presence: true

  before_save :finalize
  after_save :finalize_order

  def as_json(options = { })
    h = super(options.merge({ except: [:id, :created_at, :updated_at, :order_id, :product_id] }))
    h[:name]   = self.product.name
    h[:unit_price]   = self.product.price
    h[:image] = BASE_URL+self.product.image.url
    h
  end

  def unit_price
    if persisted?
      self[:price]
    else
      product.price
    end
  end

  def total_price
    unit_price * quantity
  end

  private
	  def finalize
	    self[:price] = total_price
	  end

    def finalize_order
      order.save
    end
end
