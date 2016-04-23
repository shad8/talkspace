module Api::V1
  class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :destroy]
    # before_action :check_permission, except: [:index, :show, :create]

    def index
      @users = User.all
      respond_with @users
    end

    def show
      respond_with @user
    end

    def create
      @user = User.create(user_params)
      respond_with @user, location: nil
    end

    def update
      @user.update(user_params)
      respond_with @user
    end

    def destroy
      @user.destroy
      head :no_content
    end

    private

    def check_permission
      return render_forbidden unless @user == Session.current_user(user_token)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :login, :password)
    end
  end
end
