class Api::V1::Drivers::OrdersController < Api::DriverApiController
	before_action :authenticate_driver_from_token!

	def index
		orders = current_driver.orders.order("created_at desc")
		response = {success: true, data: orders, errors: []}
    render status: 200, json: response
	end

	def update
		order = current_driver.orders.where(id: params[:id]).first
		if order.present?
			order.status_cd = 1
			if order.save
				response = {success: true, data: order, errors: []}
		    render status: 200, json: response
			else
				response = {success: false, data: {}, errors: order.errors.full_messages}
		    render status: 400, json: response
			end
		else
			response = {success: false, data: {}, errors: ["Order Not Found"]}
	    render status: 400, json: response
		end
	end

	def show
		order = current_driver.orders.where(id: params[:id]).first
		if order.present?
			response = {success: true, data: order, errors: []}
	    render status: 200, json: response
		else
			response = {success: false, data: {}, errors: ["Order Not Found"]}
	    render status: 400, json: response
		end
	end
end
