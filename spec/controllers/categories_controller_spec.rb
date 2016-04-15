require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  before { request.env['HTTP_ACCEPT'] = 'application/json' }
  let(:user) { create(:user, login: rand_text, email: rand_email) }
  let!(:category) { create(:category_with_posts, name: rand_text, user: user) }
  let(:params) { attributes_for(:category) }

  describe 'GET index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to match_response_schema('categories')
    end
  end

  describe 'GET show' do
    it 'returns http success' do
      get :show, params: { id: category }
      expect(response).to have_http_status(:success)
      expect(response).to match_response_schema('category_with_posts')
    end

    it 'returns http not_found' do
      rand_id = rand(5) + 100
      get :show, params: { id: rand_id }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST create' do
    it 'returns http created and save category' do
      params[:user_id] = rand + 1
      expect do
        post :create, params: { category: params }
      end.to change(Category, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(response).to match_response_schema('category')
    end
  end

  describe 'PUT update' do
    it 'returns http no_content' do
      params[:name] = rand_text 10
      put :update, params: { id: category, category: params }
      expect(response).to have_http_status(:no_content)
    end

    it 'returns http unprocessable_entity with empty name' do
      params[:name] = ''
      put :update, params: { id: category, category: params }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE destroy' do
    it 'returns http :no_content' do
      expect do
        delete :destroy, params: { id: category }
      end.to change(Category, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it 'destroy category with posts' do
      post_count = category.posts.count
      expect do
        delete :destroy, params: { id: category }
      end.to change(Post, :count).by(-post_count)
    end
  end
end
