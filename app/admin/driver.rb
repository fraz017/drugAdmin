ActiveAdmin.register Driver do

	# See permitted parameters documentation:
	# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
	#
	permit_params :first_name, :last_name, :phone_number, :email, :password, :password_confirmation, items_attributes: [ :id, :product_id, :quantity, :_destroy ]
	#
	# or
	#
	# permit_params do
	#   permitted = [:permitted, :attributes]
	#   permitted << :other if params[:action] == 'create' && current_user.admin?
	#   permitted
	# end

	filter :first_name
  filter :last_name
  filter :phone_number
  filter :email

	index do
	  selectable_column
	  column :first_name
	  column :last_name
	  column :phone_number
	  column :email
		actions
	end


	form do |f|
		f.inputs 'Driver' do
	    f.input :first_name
	    f.input :last_name
	    f.input :phone_number
	    f.input :email
	    f.input :password
	    f.input :password_confirmation
	  end
	  f.inputs "Inventory" do
      f.has_many :items, heading: "Assign Products and Quantity", new_record: 'Add New Product', allow_destroy: true do |d|
        d.input :product, :as => :select, :multiple => false, :input_html => { :size => 1 }
        d.input :quantity
      end
    end
	  f.actions
	end

	show do |d|
    attributes_table do
      row :first_name
      row :last_name
      row :phone_number
      row :email
    end

    panel "Inventory" do
      table_for driver.items do
			  column "Product Name" do |item|
			    item.product.name
			  end
			  column "Unit Price" do |item|
			    item.product.price
			  end
			  column "Product Image" do |item|
			    image_tag(item.product.image.url, size: "50x50")
			  end
			  column "Assigned Quantity" do |item|
			    item.quantity
			  end
      end
    end
  end

  controller do
	  def update
	    if params[:driver][:password].blank? && params[:driver][:password_confirmation].blank?
	      params[:driver].delete("password")
	      params[:driver].delete("password_confirmation")
	    end
	    super
		end
	end	
end
