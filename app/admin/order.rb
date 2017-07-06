ActiveAdmin.register Order do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :driver_id, :status_cd, :user_id, :prescription, :photo, product_orders_attributes: [ :id, :product_id, :quantity, :_destroy ], shipping_address_attributes: [:id, :street1, :street2, :city, :state, :zipcode, :country], billing_address_attributes: [:id, :street1, :street2, :city, :state, :zipcode, :country]
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

	index do
	  selectable_column
	  column :id
	  column :order_number
	  column "Order Total" do |post|
	    post.total
	  end
	  column :user
	  column :driver
	  column "Status" do |post|
	    post.status.to_s.humanize
	  end
		actions
	end


	form do |f|
		f.inputs 'Order' do
	    f.input :user_id, as: :select, collection: User.all.map{|u| [u.email, u.id]}
	    f.input :driver_id, as: :select, collection: Driver.all.map{|u| [u.email, u.id]}
	    f.input :status_cd, label: "Status", :as => :select, :collection => Order.statuses.map { |k,v| [k.to_s.titleize, v] }
	    f.input :prescription, as: :file
	    f.input :photo, as: :file
	  end

	  f.inputs "Shipping Address", for: [:shipping_address, f.object.shipping_address || ShippingAddress.new] do |d|
    	d.input :street1
    	d.input :street2
    	d.input :city
    	d.input :state
    	d.input :zipcode
    	d.input :country, :as => :string

    	d.actions
    end

    # f.inputs "Billing Address", for: [:billing_address, f.object.billing_address || BillingAddress.new] do |d|
    # 	d.input :street1
    # 	d.input :street2
    # 	d.input :city
    # 	d.input :state
    # 	d.input :zipcode
    # 	d.input :country, :as => :string

    # 	d.actions
    # end
	  
  	f.has_many :product_orders, heading: "Add/Edit Products and Quantity", new_record: 'Add New Order Item', allow_destroy: true do |d|
    	d.input :product, :as => :select, :multiple => false, :input_html => { :size => 1 }
    	d.input :quantity
    end

	  f.actions
	end

	show do |d|
    attributes_table do
      row :user
      row :driver
      row "Order Total" do |post|
		    post.total
		  end
      row "Status" do |post|
		    post.status.to_s.humanize
		  end
      row :order_number
      row "Prescription" do |item|
		    link_to(image_tag(item.prescription.url, size: "50x50"),item.prescription.url, target: "_blank")
		  end
		  row "Photo ID" do |item|
		    link_to(image_tag(item.photo.url, size: "50x50"),item.photo.url, target: "_blank")
		  end
    end
    panel "Order Items" do
      table_for order.product_orders do
			  column "Name" do |item|
			    item.product.name
			  end
			  column "Unit Price" do |item|
			    item.product.price
			  end
			  column :quantity
			  column "Sub Total" do |item|
			    item.price
			  end
			  column "Image" do |item|
			    image_tag(item.product.image.url, size: "50x50")
			  end
      end
    end
    panel "Shipping Address" do
      table_for order.shipping_address do
			  column "Street 1" do |item|
			    item.street1
			  end
			  column "Street 2" do |item|
			    item.street2
			  end
			  column "City" do |item|
			    item.city
			  end
			  column "State" do |item|
			    item.state
			  end
			  column "Zipcode" do |item|
			    item.zipcode
			  end
			  column "Country" do |item|
			    item.country
			  end
      end
    end
    panel "User" do
      table_for order.user do
			  column "First Name" do |user|
			    user.try(:first_name)
			  end
			  column "Last Name" do |user|
			    user.try(:last_name)
			  end
			  column "Email" do |user|
			    user.try(:email)
			  end
			  column "Phone" do |user|
			    user.try(:phone_number)
			  end
      end
    end
  end
end
