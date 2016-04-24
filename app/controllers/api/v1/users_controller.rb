module Api::V1
  class UsersController < ApplicationController
    skip_before_action :authenticate, only: :create
    before_action :set_user, only: [:show, :update, :destroy]
    before_action :check_permission, except: [:index, :show, :create]

    def index
      @users = User.all
      respond_with @users
    end

    def show
      respond_with @user
    end

    def create
      @user = User.create(user_params)
      respond_with @user, location: nil, serializer: UserWithTokenSerializer,
                          root: 'user'
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
      return render_forbidden unless @user == @current_user
    end

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :login, :password)
    end
  end
end
