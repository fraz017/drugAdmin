class Product < ApplicationRecord
	validates_presence_of :price, :name
	has_attached_file :image, default_url: "/assets/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  def as_json(options = { })
    h = super(options.merge({ except: [:created_at, :updated_at, :image_file_size, :image_content_type, :image_file_name, :image_updated_at] }))
    h[:image]   = "suavistech.com:3001/"self.image.url
    h
  end
end
