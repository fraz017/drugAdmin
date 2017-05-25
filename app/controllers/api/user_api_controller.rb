class Api::UserApiController < ApplicationController
  respond_to :json

  before_action :authenticate_user_from_token!

  def authenticate_user_from_token!
    auth_token = request.headers['HTTP_AUTHORIZATION']

    if auth_token
      authenticate_with_auth_token(auth_token)
    else
      authentication_error
    end
  end

  private

  def authenticate_with_auth_token(auth_token)

    user = User.where(access_token: auth_token).first
    if user && Devise.secure_compare(user.access_token, auth_token)
      sign_in(user, store: false)
    else
      authentication_error
    end
  end

  def authentication_error
    # User's token is either invalid or not in the right format
    render(json: {success: false, data: [], errors: t('devise.failure.unauthenticated')}, status: 401)  # Authentication timeout
  end
end