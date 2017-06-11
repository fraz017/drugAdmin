class Api::V1::Users::OrdersController < Api::UserApiController
	before_action :authenticate_user_from_token!

	def index
		orders = current_user.orders.order("created_at desc")
		response = {success: true, data: orders, errors: []}
    render status: 200, json: response
	end

	def create
		order_params = params[:order].permit!
		permitted = params.require(:product_orders).map { |m| m.permit(:product_id, :quantity) }
		order = Order.new(order_params)
		order.user = current_user
		order.product_orders.build(permitted)
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
end
