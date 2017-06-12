class Product < ApplicationRecord

	BASE_URL = "http://173.255.221.38"
  # BASE_URL = "http://localhost:3000"
	validates_presence_of :price, :name
	has_attached_file :image, default_url: "/assets/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  has_many :product_orders
  has_many :orders, through: :product_orders
  has_many :items

  def as_json(options = { })
    h = super(options.merge({ except: [:created_at, :updated_at, :image_file_size, :image_content_type, :image_file_name, :image_updated_at] }))
    h[:image]   = BASE_URL+self.image.url
    h
  end
end
