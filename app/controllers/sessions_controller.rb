class SessionsController < ApplicationController
  before_action :set_user, only: [:create]
  before_action :set_token, only: [:update, :destroy]

  def create
    if @user && @user.authenticate(user_params[:password])
      render_user_with_token
    else
      render json: { errors: :session_invalid }, status: :unprocessable_entity
    end
  end

  def update
    if @session
      render json: @session, status: :ok
    else
      render json: { errors: unauthorized }, status: :unauthorized
    end
  end

  def destroy
  end

  private

  def render_user_with_token
    @user.token = Session.create(user: @user).token
    render json: @user, status: :created
  end

  # TODO: MOve to I18n
  def session_invalid
    'Email or password was invalid'
  end

  # TODO: MOve to I18n
  def unauthorized
    'Unauthorized'
  end

  def set_token
    @session = Session.find_by(token: user_token)
  end

  def set_user
    @user = User.find_by(
      email: user_params[:email], login: user_params[:login]
    )
  end

  def user_params
    params.require(:user).permit(:email, :login, :password)
  end

  def user_token
    request.headers['X-User-Token']
  end
end
