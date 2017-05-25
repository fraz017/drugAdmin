class Api::V1::Users::RegistrationsController < Api::UserApiController
  skip_before_action :authenticate_user_from_token!
  
  respond_to :json
  def create
    user = User.new(user_params)
    user.access_token = Devise.friendly_token
    if user.save
      response = {success: true, data: user, errors:[]}
      render :json=> response, :status=>201
      return
    else
      warden.custom_failure!
      response = {success: false, data: {}, errors:user.errors.full_messages}
      render :json=> response, :status=>422
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone_number, :email, :password, :password_confirmation)
  end
end
