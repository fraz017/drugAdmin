class BillingAddress < ApplicationRecord
	belongs_to :order
	def as_json(options = {})
    h = super(options.merge({ except: [:created_at, :updated_at, :order_id, :id] }))
    h
  end
  validates_presence_of :city, :street1, :state, :zipcode
end
