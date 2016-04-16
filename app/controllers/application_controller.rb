class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  respond_to :json

  before_action :authenticate

  private

  def authenticate
    authenticate_token || render_unauthenticate
  end

  def authenticate_token
    authenticate_with_http_token do |token|
      Rails.application.secrets.authenticate_token == token
    end
  end

  def errors(key)
    t(key, scope: :errors)
  end

  def render_forbidden
    render json: { errors: errors(:forbidden) }, status: :forbidden
  end

  def record_not_found
    render json: { errors: errors(:not_found) }, status: :not_found
  end

  def render_unauthenticate
    render json: { errors: errors(:unauthorized) }, status: :unauthorized
  end

  def user_token
    request.headers['X-User-Token']
  end
end
