class Api::DriverApiController < ApplicationController
  respond_to :json

  before_action :authenticate_driver_from_token!

  def authenticate_driver_from_token!
    auth_token = request.headers['HTTP_AUTHORIZATION']

    if auth_token
      authenticate_with_auth_token(auth_token)
    else
      authentication_error
    end
  end

  private

  def authenticate_with_auth_token(auth_token)

    driver = Driver.where(access_token: auth_token).first
    if driver && Devise.secure_compare(driver.access_token, auth_token)
      sign_in(driver, store: false)
    else
      authentication_error
    end
  end

  def authentication_error
    # driver's token is either invalid or not in the right format
    render(json: {success: false, data: [], errors: t('devise.failure.unauthenticated')}, status: 401)  # Authentication timeout
  end
end