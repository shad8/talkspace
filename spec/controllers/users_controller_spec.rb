require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET index' do
    it 'returns http success' do
      get :index, format: :json
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET create' do
    it 'returns http created' do
      get :create, format: :json
      expect(response).to have_http_status(:created)
    end
  end

  describe 'GET show' do
    it 'returns http success' do
      get :show, format: :json
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET update' do
    it 'returns http no_content' do
      get :update, format: :json
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'GET destroy' do
    it 'returns http :no_content' do
      get :destroy, format: :json
      expect(response).to have_http_status(:no_content)
    end
  end
end
