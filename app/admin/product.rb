ActiveAdmin.register Product do

	# See permitted parameters documentation:
	# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
	#
	permit_params :name, :price, :quantity, :image, :description, :ingredients
	#
	# or
	#
	# permit_params do
	#   permitted = [:permitted, :attributes]
	#   permitted << :other if params[:action] == 'create' && current_user.admin?
	#   permitted
	# end

	filter :name
  filter :price

	index do
	  selectable_column
	  column :name
	  column :price
	  column :quantity
	  column "Image" do |product|
		  link_to(image_tag(product.image.url, size: "50x50"),product.image.url, target: "_blank")
		end
		actions
	end

	form do |f|
		f.inputs 'Drug' do
	    f.input :name
	    f.input :price
	    f.input :quantity
	    f.input :image, :as => :file
	    f.input :description
	    f.input :ingredients
	  end
	  f.actions
	end

	show do |d|
    attributes_table do
      row :name
      row :price
      row :quantity
      row :image do
      	link_to(image_tag(d.image.url, size: "200x200"),d.image.url, target: "_blank")
      end
      row :description
      row :ingredients
    end
  end


end
