class ApplicationController < ActionController::API
  # before_action :doorkeeper_authorize!

  private
  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token.try(:[], :resource_owner_id))
    @current_user ||= User.find_by(email: 'test3@test.com')
  end
end
