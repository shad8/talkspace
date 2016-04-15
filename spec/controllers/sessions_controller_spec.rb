require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before { request.env['HTTP_ACCEPT'] = 'application/json' }
  let!(:user) { create(:user) }
  let(:params) { attributes_for(:user) }

  describe 'POST create' do
    it 'returns http created and create new session' do
      expect do
        post :create, params: { user: params }
      end.to change { Session.count }.by(1)
      expect(response).to have_http_status(:created)
      expect(response).to match_response_schema('user')
    end

    context 'with invalid user email' do
      it 'returns http :unprocessable_entity' do
        params[:email] = ''
        post :create, params: { user: params }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'not create session' do
        params[:email] = ''
        expect do
          post :create, params: { user: params }
        end.to change { Session.count }.by(0)
      end

      it 'and wrong password returns http :unprocessable_entity' do
        params[:password] = 'wrong'
        post :create, params: { user: params }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT update' do
    let(:next_user) { create(:user, login: rand_text, email: rand_email) }
    let(:session) { create(:session, user_id: next_user.id) }

    it 'with access returns http success' do
      request.headers['X-User-Token'] = session.token
      put :update
      expect(response).to have_http_status(:success)
    end

    it 'without access returns http unauthorized' do
      request.headers['X-User-Token'] = rand_text
      put :update
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE destroy' do
    it 'returns http success' do
      delete :destroy
      expect(response).to have_http_status(:success)
    end
  end
end
