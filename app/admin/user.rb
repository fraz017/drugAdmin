ActiveAdmin.register User do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
permit_params :first_name, :last_name, :phone_number, :email, :password, :password_confirmation
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
		f.inputs 'User' do
	    f.input :first_name
	    f.input :last_name
	    f.input :phone_number
	    f.input :email
	    f.input :password
	    f.input :password_confirmation
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
  end

 	controller do
	  def update
	    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
	      params[:user].delete("password")
	      params[:user].delete("password_confirmation")
	    end
	    super
		end
	end
end
