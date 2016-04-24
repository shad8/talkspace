require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:user) { create(:user, email: rand_email, login: rand_text) }
  let(:params) { attributes_for(:user) }
  let(:host) { 'http://api.example.com' }

  before do
    request.env['HTTP_ACCEPT'] = 'application/json'
    request.env['HTTP_AUTHORIZATION'] = encoded_service_token user.token
  end

  it { is_expected.to use_before_action(:check_permission) }

  describe 'GET index' do
    it do
      is_expected.to route(:get, "#{host}/users")
        .to(action: :index, subdomain: 'api', format: :json)
    end

    it 'returns http status code success' do
      create(:user)
      get :index
      is_expected.to respond_with(:success)
      expect(response).to match_response_schema('users')
    end
  end

  describe 'POST create' do
    it do
      is_expected.to route(:post, "#{host}/users")
        .to(action: :create, subdomain: 'api', format: :json)
    end

    # TODO: DEPRECATION WARNING:
    #       ActionController::TestCase HTTP request methods will accept only
    #       keyword arguments in future Rails versions.
    it 'restrict parameters on :user to :email, :login, :password' do
      is_expected.to permit(:email, :login, :password)
        .for(:create, params: { user: params }).on(:user)
    end

    it 'returns http status code created and save user' do
      expect do
        post :create, params: { user: params }
      end.to change(User, :count).by(1)
      is_expected.to respond_with(:created)
      expect(response).to match_response_schema('user_with_token')
    end

    it 'returns http status code unprocessable_entity for not unique login' do
      params[:login] = user.login
      post :create, params: { user: params }
      is_expected.to respond_with(:unprocessable_entity)
    end
  end

  describe 'GET show' do
    it do
      is_expected.to route(:get, "#{host}/users/#{user.id}")
        .to(action: :show, subdomain: 'api', format: :json, id: user.id)
    end

    it 'returns http status code success' do
      get :show, params: { id: user }
      is_expected.to respond_with(:success)
      expect(response).to match_response_schema('user')
    end

    it 'returns http status code not_found' do
      rand_id = rand(5) + 100
      get :show, params: { id: rand_id }
      is_expected.to respond_with(:not_found)
    end
  end

  describe 'PUT update' do
    it do
      is_expected.to route(:put, "#{host}/users/#{user.id}")
        .to(action: :update, subdomain: 'api', format: :json, id: user.id)
    end

    # TODO: DEPRECATION WARNING:
    #       ActionController::TestCase HTTP request methods will accept only
    #       keyword arguments in future Rails versions.
    it 'restrict parameters on :user to :email, :login, :password' do
      is_expected.to permit(:email, :login, :password)
        .for(:update, params: { id: user, user: params }).on(:user)
    end

    it 'returns http status code no_content' do
      params[:email] = rand_email
      put :update, params: { id: user, user: params }
      is_expected.to respond_with(:no_content)
    end

    it 'returns http status code unprocessable_entity with empty login' do
      params[:login] = ''
      put :update, params: { id: user, user: params }
      is_expected.to respond_with(:unprocessable_entity)
    end

    it 'returns http status code forbidden for not owner' do
      token = create(:user, email: rand_email, login: rand_text).token
      request.env['HTTP_AUTHORIZATION'] = encoded_service_token token
      put :update, params: { id: user, user: params }
      is_expected.to respond_with(:forbidden)
    end
  end

  describe 'DELETE destroy' do
    it do
      is_expected.to route(:delete, "#{host}/users/#{user.id}")
        .to(action: :destroy, subdomain: 'api', format: :json, id: user.id)
    end

    it 'returns http status code :no_content' do
      expect do
        delete :destroy, params: { id: user }
      end.to change(User, :count).by(-1)
      is_expected.to respond_with(:no_content)
    end

    it 'returns http status code forbidden for not owner' do
      token = create(:user, email: rand_email, login: rand_text).token
      request.env['HTTP_AUTHORIZATION'] = encoded_service_token token
      expect do
        delete :destroy, params: { id: user }
      end.to change(User, :count).by(0)
      is_expected.to respond_with(:forbidden)
    end
  end
end
