class Api::V1::Users::OrdersController < Api::UserApiController
	before_action :authenticate_user_from_token!

	def index
		orders = current_user.orders.order("created_at desc")
		response = {success: true, data: orders, errors: []}
    render status: 200, json: response
	end

	def create
		order = Order.new(order_params)
		order.user = current_user
		# order.product_orders.build(permitted)
		if order.save
			response = {success: true, data: order, errors: []}
	    render status: 200, json: response
		else
			response = {success: false, data: {}, errors: order.errors.full_messages}
	    render status: 400, json: response
		end
	end

	def show
		order = current_user.orders.where(id: params[:id]).first
		if order.present?
			response = {success: true, data: order, errors: []}
	    render status: 200, json: response
		else
			response = {success: false, data: {}, errors: ["Order Not Found"]}
	    render status: 400, json: response
		end
	end

	def last_address
		order = current_user.orders.last
		if order.present?
			data = {
				address: {
		      street1: order.try(:shipping_address).try(:street1),
		      street2: order.try(:shipping_address).try(:street2),
		      city: order.try(:shipping_address).try(:city),
		      state: order.try(:shipping_address).try(:state),
		      zipcode: order.try(:shipping_address).try(:zip),
		      country: order.try(:shipping_address).try(:country)
		    }
		  }
	    response = {success: true, data: data, errors: []}
	    render status: 200, json: response
	  else
	  	response = {success: true, data: [], errors: []}
	    render status: 200, json: response
	  end  
	end

	private

  def order_params
    params.require(:order).permit(:photo, :prescription, product_orders_attributes: [:id, :product_id, :quantity], 
    	shipping_address_attributes: [:id, :street1, :street2, :city, :state, :zipcode, :country], 
    	billing_address_attributes: [:id, :street1, :street2, :city, :state, :zipcode, :country])
  end
end
