ActiveAdmin.register Order do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :driver_id, :status_cd
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
	  column :total
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
	    f.input :total
	    f.input :status_cd, label: "Status", :as => :select, :collection => Order.statuses.map { |k,v| [k.to_s.titleize, v] }
	    f.input :order_number
	  end
	  f.actions
	end

	show do |d|
    attributes_table do
      row :user
      row :driver
      row :total
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
    panel "User" do
      table_for order.user do
			  column "First Name" do |user|
			    user.first_name
			  end
			  column "Last Name" do |user|
			    user.last_name
			  end
			  column "Email" do |user|
			    user.email
			  end
			  column "Phone" do |user|
			    user.phone_number
			  end
      end
    end
  end
end
