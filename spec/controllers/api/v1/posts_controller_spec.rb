require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  let(:user) do
    create(:user, login: rand_text, email: rand_email)
  end
  let(:user_post) { create(:post, user: user) }
  let(:params) { attributes_for(:post) }
  let(:host) { 'http://api.example.com' }

  before do
    request.env['HTTP_ACCEPT'] = 'application/json'
    request.env['HTTP_AUTHORIZATION'] = encoded_service_token user.token
  end

  it { is_expected.to use_before_action(:check_permission) }

  # TODO: All post by category
  describe 'GET index' do
    it do
      is_expected.to route(:get, "#{host}/posts")
        .to(action: :index, subdomain: 'api', format: :json)
    end

    it 'returns http status code success' do
      create(:post)
      get :index
      is_expected.to respond_with(:success)
      expect(response).to match_response_schema('posts')
    end
  end

  describe 'GET show' do
    it do
      is_expected.to route(:get, "#{host}/posts/#{user_post.id}")
        .to(action: :show, subdomain: 'api', format: :json, id: user_post.id)
    end

    it 'returns http status code success' do
      get :show, params: { id: user_post }
      is_expected.to respond_with(:success)
      expect(response).to match_response_schema('post')
    end

    it 'returns http status code not_found' do
      rand_id = rand(5) + 1
      get :show, params: { id: rand_id }
      is_expected.to respond_with(:not_found)
    end
  end

  describe 'POST create' do
    before do
      params[:user_id] = user_post.user.id
      params[:category_id] = user_post.category.id
    end

    it do
      is_expected.to route(:post, "#{host}/posts")
        .to(action: :create, subdomain: 'api', format: :json)
    end

    # TODO: DEPRECATION WARNING:
    #       ActionController::TestCase HTTP request methods will accept only
    #       keyword arguments in future Rails versions.
    it "restrict parameters on :post to :title, :body, :user_id,
        :category_id" do
      is_expected.to permit(:title, :body, :user_id, :category_id)
        .for(:create, params: { post: params }).on(:post)
    end

    it 'returns http status code created and save post' do
      expect do
        post(:create, params: { post: params })
      end.to change(Post, :count).by(1)
      is_expected.to respond_with(:created)
      expect(response).to match_response_schema('post')
    end

    it 'return http status code unprocessable_entity and not create post' do
      params[:title] = ''
      post :create, params: { post: params }
      is_expected.to respond_with(:unprocessable_entity)
    end

    it 'for not acces for guest returns http status code forbidden' do
      expect do
        post :create, params: { post: params }
      end.to change(Post, :count).by(0)
      is_expected.to respond_with(:forbidden)
    end
  end

  describe 'PUT update' do
    it do
      is_expected.to route(:put, "#{host}/posts/#{user_post.id}")
        .to(action: :update, subdomain: 'api', format: :json, id: user_post.id)
    end

    # TODO: DEPRECATION WARNING:
    #       ActionController::TestCase HTTP request methods will accept only
    #       keyword arguments in future Rails versions.
    it "restrict parameters on :post to :title, :body, :user_id,
        :category_id" do
      is_expected.to permit(:title, :body, :user_id, :category_id)
        .for(:update, params: { id: user_post, post: params }).on(:post)
    end

    it 'returns http status code no_content' do
      params[:title] = rand_text 10
      put :update, params: { id: user_post, post: params }
      is_expected.to respond_with(:no_content)
    end

    it 'returns http status code unprocessable_entity with empty title' do
      params[:title] = ''
      put :update, params: { id: user_post, post: params }
      is_expected.to respond_with(:unprocessable_entity)
    end

    it 'returns http status code forbidden for not owner' do
      user = create(:user_with_sessions, email: rand_email, login: rand_text)
      put :update, params: { id: user_post, post: params }
      is_expected.to respond_with(:forbidden)
    end
  end

  describe 'DELETE destroy' do
    let!(:post) { create(:post, user: user) }

    it do
      is_expected.to route(:delete, "#{host}/posts/#{post.id}")
        .to(action: :destroy, subdomain: 'api', format: :json, id: post.id)
    end

    it 'returns http status code :no_content' do
      expect do
        delete :destroy, params: { id: post }
      end.to change(Post, :count).by(-1)
      is_expected.to respond_with(:no_content)
    end

    it 'returns http status code forbidden for not owner' do
      expect do
        delete :destroy, params: { id: post }
      end.to change(Post, :count).by(0)
      is_expected.to respond_with(:forbidden)
    end
  end
end
