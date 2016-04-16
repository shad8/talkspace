class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :update, :destroy]
  before_action :check_permission, except: [:index, :show]

  def index
    @categories = Category.all
    respond_with @categories
  end

  def show
    respond_with @category, serializer: CategoryWithPostsSerializer,
                            root: 'category'
  end

  def create
    @category = Category.create(category_params)
    respond_with @category
  end

  def update
    @category.update(category_params)
    respond_with @category
  end

  def destroy
    @category.destroy
    head :no_content
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :user_id)
  end

  def check_permission
    authorization = Authorization.new(user_token, @category)
    return render_forbidden unless authorization.permitted
  end
end
