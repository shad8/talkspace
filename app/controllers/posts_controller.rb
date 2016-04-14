class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  def index
    @posts = Post.all
    respond_with @posts
  end

  def show
    respond_with @post
  end

  def create
    @post = Post.create(post_params)
    respond_with @post, location: nil
  end

  def update
    @post.update(post_params)
    respond_with @post
  end

  def destroy
    @post.destroy
    head :no_content
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :user_id, :category_id)
  end
end
