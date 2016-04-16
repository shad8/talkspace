require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) do
    create(:user_with_sessions, login: rand_text, email: rand_email)
  end
  let(:user_post) { create(:post, user: user) }
  let(:params) { attributes_for(:post) }

  before do
    request.env['HTTP_ACCEPT'] = 'application/json'
    request.env['HTTP_AUTHORIZATION'] = encoded_service_token
    request.headers['X-User-Token'] = user.sessions.first.token
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

    it 'not acces for guest' do
      request.headers['X-User-Token'] = rand_text
      expect do
        post :create, params: { post: params }
      end.to change(Post, :count).by(0)
      expect(response).to have_http_status(:forbidden)
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

    it 'forbidden for not owner' do
      user = create(:user_with_sessions, email: rand_email, login: rand_text)
      request.headers['X-User-Token'] = user.sessions.first.token
      put :update, params: { id: user_post, post: params }
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'DELETE destroy' do
    let!(:post) { create(:post, user: user) }

    it 'returns http :no_content' do
      expect do
        delete :destroy, params: { id: post }
      end.to change(Post, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it 'forbidden for not owner' do
      request.headers['X-User-Token'] = rand_text
      expect do
        delete :destroy, params: { id: post }
      end.to change(Post, :count).by(0)
      expect(response).to have_http_status(:forbidden)
    end
  end
end
