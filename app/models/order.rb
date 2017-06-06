class Order < ApplicationRecord
  belongs_to :user
  belongs_to :driver

  after_create :set_order_number

  has_many :product_orders
  has_many :products, through: :product_orders

  as_enum :status, in_progress: 0, completed: 1

  before_save :update_total

  accepts_nested_attributes_for :product_orders

  def as_json(options = { })
    h = super(options.merge({ except: [:created_at, :updated_at, :status_cd, :user_id, :driver_id] }))
    h[:status]   = self.status.to_s.humanize
    h[:items] = self.product_orders
    h
  end

  def set_order_number
  	self.order_number = "SF-%.7d" % id
  	self.save
  end

  def total
    p = product_orders.collect { |o| o.price.present? ? o.price : 0 }.sum
  	return p
  end

  private
    def update_total
      self[:total] = total
    end
end
