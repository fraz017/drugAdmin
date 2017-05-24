class Product < ApplicationRecord
	validates_presence_of :price, :name
	has_attached_file :image, default_url: "/assets/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
