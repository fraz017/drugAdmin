class Api::V1::Drivers::SessionsController < Api::DriverApiController
  skip_before_action :authenticate_driver_from_token!, only: [:create]

  def create
    @user = Driver.find_for_database_authentication(email: params[:email])
    return invalid_login_attempt unless @user

    if @user.valid_password?(params[:password])
      if @user.access_token.nil?
        @user.access_token = Devise.friendly_token
        @user.save
      end  
      @response = {success: true, data: @user, errors: @user.errors.full_messages}
      render status: 200, json: @response
    else
      invalid_login_attempt
    end
  end

  def destroy
    current_driver.access_token = Devise.friendly_token
    current_driver.save
    sign_out(current_driver)
    @response = {success: true, data: [], errors: []}
    render status: 200, json: @response
  end

  private

  def invalid_login_attempt
    warden.custom_failure!
    @response = {success: false, data: {}, errors: [t('devise.failure.invalid', authentication_keys: "email")]}
    render status: 400, json: @response
  end
end