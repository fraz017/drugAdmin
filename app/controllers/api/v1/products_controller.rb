class Api::V1::ProductsController < ApplicationController

  def index
  	@products = Product.all
  	response = {success: true, data: @products, errors: []}
    render status: 200, json: response
  end

  def show
  	@product = Product.where(id: params[:id]).first
  	if @product 
  		response = {success: true, data: @product, errors: []}
	    render status: 200, json: response
  	else
  		response = {success: false, data: {}, errors: ["Product not found"]}
	    render status: 400, json: response
  	end
  end

end
