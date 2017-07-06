class Order < ApplicationRecord

  BASE_URL = "http://173.255.221.38"
  # BASE_URL = "http://localhost:3000"
  belongs_to :user
  belongs_to :driver

  after_create :set_order_number

  has_many :product_orders, dependent: :destroy
  has_many :products, through: :product_orders

  has_one :shipping_address, dependent: :destroy
  # has_one :billing_address, dependent: :destroy

  validates_associated :product_orders
  validates_presence_of :shipping_address
  # validates_presence_of :billing_address

  as_enum :status, in_progress: 0, completed: 1

  after_save :update_total

  before_save :update_quantity

  accepts_nested_attributes_for :product_orders
  accepts_nested_attributes_for :shipping_address
  # accepts_nested_attributes_for :billing_address

  has_attached_file :prescription, default_url: "/assets/missing.png"
  validates_attachment_content_type :prescription, content_type: /\Aimage\/.*\z/

  has_attached_file :photo, default_url: "/assets/missing.png"
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/

  validates_attachment_presence :prescription
  validates_attachment_presence :photo

  def as_json(options = { })
    h = super(options.merge({ except: [:created_at, :updated_at, :status_cd, :user_id, :driver_id, :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at, :prescription_file_name, :prescription_content_type, :prescription_file_size, :prescription_updated_at] }))
    h[:status]   = self.status.to_s.humanize.titleize
    h[:items] = self.product_orders
    h[:shipping_address] = self.shipping_address
    # h[:billing_address] = self.billing_address
    h[:prescription]   = BASE_URL+self.prescription.url
    h[:image]   = BASE_URL+self.photo.url
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

  def update_quantity
    if driver.present?
      product_orders.each do |p|
        item = Item.where(product_id: p.product_id, driver_id: driver.id).first
        if item.present? && !p.dealt
          item.quantity = item.quantity - p.quantity
          item.save
          p.dealt = true
          p.save
        end
      end
    end
  end

  private
    def update_total
      self[:total] = total
    end
end
