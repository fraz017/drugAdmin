class Order < ApplicationRecord

  BASE_URL = "http://173.255.221.38"
  # BASE_URL = "http://localhost:3000"
  belongs_to :user
  belongs_to :driver

  after_create :set_order_number

  has_many :product_orders
  has_many :products, through: :product_orders

  as_enum :status, in_progress: 0, completed: 1

  before_save :update_total

  accepts_nested_attributes_for :product_orders

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

  private
    def update_total
      self[:total] = total
    end
end
