class SessionsController < ApplicationController
  before_action :set_user, only: [:create]
  before_action :set_token, only: [:update, :destroy]

  # TODO: Refactoring
  def create
    if @user && @user.authenticate(user_params[:password])
      render_user
    else
      render json: { errors: errors(:invalid) }, status: :unprocessable_entity
    end
  end

  def update
    @session ? respond_with(@session) : render_unauthenticate
  end

  def destroy
    @session && @session.destroy
    :no_content
  end

  private

  def render_user
    @user.token = Session.create(user: @user).token
    respond_with @user, serializer: UserSerializer, location: nil
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
end
