class UsersController < ApplicationController
  skip_before_action :doorkeeper_authorize!, only: [:create]

  def create
    user = User.new(user_params)
    client_app = Doorkeeper::Application.find_by(uid: params[:client_id])
    return render(json: { error: 'Invalid client ID'}, status: 403) unless client_app

    if user.save
      # create access token for the user, so the user won't need to login again after registration
      access_token = Doorkeeper::AccessToken.create(
        resource_owner_id: user.id,
        application_id: client_app.id,
        expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
        scopes: ''
      )

      # return json containing access token and refresh token
      # so that user won't need to call login API right after registration
      render json: {
        user: {
          id: user.id,
          email: user.email,
          access_token: access_token.token,
          token_type: 'bearer',
          expires_in: access_token.expires_in,
          created_at: access_token.created_at.to_time.to_i
        }
      }
    else
      render json: { error: user.errors.full_messages }, status: 422
    end
  end

  private
  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end