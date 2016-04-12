require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:params) { attributes_for(:user) }

  before { request.env['HTTP_ACCEPT'] = 'application/json' }

  describe 'GET index' do
    it 'returns http success' do
      create(:user)
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to match_response_schema('users')
    end
  end

  describe 'POST create' do
    it 'returns http created and save user' do
      expect do
        post :create, params: { user: params }
      end.to change(User, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(response).to match_response_schema('user')
    end

    it 'return http unprocessable_entity and not create user' do
      params[:login] = user.login
      post :create, params: { user: params }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET show' do
    it 'returns http success' do
      get :show, params: { id: user }
      expect(response).to have_http_status(:success)
      expect(response).to match_response_schema('user')
    end

    it 'returns http not_found' do
      rand_id = rand(5) + 1
      get :show, params: { id: rand_id }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PUT update' do
    it 'returns http no_content' do
      params[:email] = rand_email
      put :update, params: { id: user, user: params }
      expect(response).to have_http_status(:no_content)
    end

    it 'returns http unprocessable_entity with empty login' do
      params[:login] = ''
      put :update, params: { id: user, user: params }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE destroy' do
    it 'returns http :no_content' do
      user = create(:user)
      expect do
        delete :destroy, params: { id: user }
      end.to change(User, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
