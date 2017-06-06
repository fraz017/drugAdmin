ActiveAdmin.register Order do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :driver_id
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
	    f.input :status
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
    end
    panel "Order Items" do
      table_for order.product_orders do
			  column "Name" do |post|
			    post.product.name
			  end
			  column "Unit Price" do |post|
			    post.product.price
			  end
			  column :quantity
			  column "Sub Total" do |post|
			    post.price
			  end
			  column "Unit Price" do |post|
			    image_tag(post.product.image.url, size: "50x50")
			  end
      end
    end
  end
end
