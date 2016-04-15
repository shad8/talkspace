require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user_post) { create(:post) }
  let(:params) { attributes_for(:post) }

  before do
    request.env['HTTP_ACCEPT'] = 'application/json'
    request.env['HTTP_AUTHORIZATION'] = encoded_service_token
  end

  # TODO: All post by category
  describe 'GET index' do
    it 'returns http success' do
      create(:post)
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to match_response_schema('posts')
    end
  end

  describe 'GET show' do
    it 'returns http success' do
      get :show, params: { id: user_post }
      expect(response).to have_http_status(:success)
      expect(response).to match_response_schema('post')
    end

    it 'returns http not_found' do
      rand_id = rand(5) + 1
      get :show, params: { id: rand_id }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST create' do
    before do
      params[:user_id] = user_post.user.id
      params[:category_id] = user_post.category.id
    end

    it 'returns http created and save post' do
      expect do
        post(:create, params: { post: params })
      end.to change(Post, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(response).to match_response_schema('post')
    end

    it 'return http unprocessable_entity and not create post' do
      params[:title] = ''
      post :create, params: { post: params }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT update' do
    it 'returns http no_content' do
      params[:title] = rand_text 10
      put :update, params: { id: user_post, post: params }
      expect(response).to have_http_status(:no_content)
    end

    it 'returns http unprocessable_entity with empty title' do
      params[:title] = ''
      put :update, params: { id: user_post, post: params }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE destroy' do
    it 'returns http :no_content' do
      post = create(:post)
      expect do
        delete :destroy, params: { id: post }
      end.to change(Post, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
