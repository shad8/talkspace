require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let!(:user) { create(:user) }
  let(:session) { create(:session, user_id: user.id) }
  let(:params) { attributes_for(:user) }

  before do
    request.env['HTTP_ACCEPT'] = 'application/json'
    request.headers['X-User-Token'] = session.token
  end

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
    it 'with access returns http success' do
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
    it 'returns http :no_content' do
      delete :destroy
      expect(response).to have_http_status(:no_content)
    end

    it 'remove user session' do
      expect { delete :destroy }.to change { Session.count }.by(-1)
    end

    it 'can not remove not exist user session' do
      request.headers['X-User-Token'] = rand_text
      expect { delete :destroy }.to change { Session.count }.by(0)
    end
  end
end
