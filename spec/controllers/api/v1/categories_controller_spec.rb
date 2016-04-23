require 'rails_helper'

RSpec.describe Api::V1::CategoriesController, type: :controller do
  let(:user) do
    create(:user_with_sessions, login: rand_text, email: rand_email)
  end
  let(:session) { create(:session, user_id: user.id) }
  let!(:category) { create(:category_with_posts, name: rand_text, user: user) }
  let(:params) { attributes_for(:category) }
  let(:host) { 'http://api.example.com' }

  before do
    request.env['HTTP_ACCEPT'] = 'application/json'
    request.env['HTTP_AUTHORIZATION'] = encoded_service_token
    request.headers['X-User-Token'] = user.sessions.first.token
  end

  it { is_expected.to use_before_action(:check_permission) }

  describe 'GET index' do
    it do
      is_expected.to route(:get, "#{host}/categories")
        .to(action: :index, subdomain: 'api', format: :json)
    end

    it 'returns http status code success' do
      get :index
      is_expected.to respond_with(:success)
      expect(response).to match_response_schema('categories')
    end
  end

  describe 'GET show' do
    it do
      is_expected.to route(:get, "#{host}/categories/#{category.id}")
        .to(action: :show, subdomain: 'api', format: :json, id: category.id)
    end

    it 'returns http status code success' do
      get :show, params: { id: category }
      is_expected.to respond_with(:success)
      expect(response).to match_response_schema('category_with_posts')
    end

    it 'returns http status code not_found' do
      rand_id = rand(5) + 100
      get :show, params: { id: rand_id }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST create' do
    it do
      is_expected.to route(:post, "#{host}/categories")
        .to(action: :create, subdomain: 'api', format: :json)
    end

    # TODO: DEPRECATION WARNING:
    #       ActionController::TestCase HTTP request methods will accept only
    #       keyword arguments in future Rails versions.
    it 'restrict parameters on :category to :name and :user_id' do
      is_expected.to permit(:name, :user_id)
        .for(:create, params: { category: params }).on(:category)
    end

    it 'returns http status code created and save category' do
      params[:user_id] = rand + 1
      expect do
        post :create, params: { category: params }
      end.to change(Category, :count).by(1)
      is_expected.to respond_with(:created)
      expect(response).to match_response_schema('category')
    end

    it 'for not acces for guest returns http status code forbidden' do
      request.headers['X-User-Token'] = rand_text
      expect do
        post :create, params: { category: params }
      end.to change(Category, :count).by(0)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'PUT update' do
    it do
      is_expected.to route(:put, "#{host}/categories/#{category.id}")
        .to(action: :update, subdomain: 'api', format: :json, id: category.id)
    end

    # TODO: DEPRECATION WARNING:
    #       ActionController::TestCase HTTP request methods will accept only
    #       keyword arguments in future Rails versions.
    it 'restrict parameters on :category to :name and :user_id' do
      is_expected.to permit(:name, :user_id)
        .for(:update, params: { id: category, category: params }).on(:category)
    end

    it 'returns http status code no_content' do
      params[:name] = rand_text 10
      put :update, params: { id: category, category: params }
      is_expected.to respond_with(:no_content)
    end

    it 'returns http status code unprocessable_entity for empty name' do
      params[:name] = ''
      put :update, params: { id: category, category: params }
      is_expected.to respond_with(:unprocessable_entity)
    end

    it 'returns http status code forbidden for not owner' do
      user = create(:user_with_sessions, email: rand_email, login: rand_text)
      request.headers['X-User-Token'] = user.sessions.first.token
      put :update, params: { id: category, category: params }
      is_expected.to respond_with(:forbidden)
    end
  end

  describe 'DELETE destroy' do
    it do
      is_expected.to route(:delete, "#{host}/categories/#{category.id}")
        .to(action: :destroy, subdomain: 'api', format: :json, id: category.id)
    end

    it 'returns http status code no_content and change Category count' do
      expect do
        delete :destroy, params: { id: category }
      end.to change(Category, :count).by(-1)
      is_expected.to respond_with(:no_content)
    end

    it 'category with posts' do
      post_count = category.posts.count
      expect do
        delete :destroy, params: { id: category }
      end.to change(Post, :count).by(-post_count)
    end

    it 'returns http status code forbidden for not owner' do
      user = create(:user_with_sessions, email: rand_email, login: rand_text)
      request.headers['X-User-Token'] = user.sessions.first.token
      put :update, params: { id: category, category: params }
      is_expected.to respond_with(:forbidden)
    end
  end
end
