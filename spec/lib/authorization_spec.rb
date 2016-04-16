require 'rails_helper'

RSpec.describe Authorization, type: :class do
  describe '#permitted' do
    let!(:user) { create(:user_with_sessions) }
    let(:user_token) { user.sessions.first.token }
    let(:object) { FakeObject.new user }

    context 'should be true' do
      it 'for admin' do
        user.update(role: :admin)
        authorization = Authorization.new(user_token, object)
        expect(authorization.permitted).to be_truthy
      end

      it 'for owner' do
        authorization = Authorization.new(user_token, object)
        expect(authorization.permitted).to be_truthy
      end

      it 'for user when resource is not set' do
        authorization = Authorization.new(user_token, nil)
        expect(authorization.permitted).to be_truthy
      end
    end

    context 'should be false' do
      it 'false for guest' do
        token = nil
        authorization = Authorization.new(token, object)
        expect(authorization.permitted).to be_falsey
      end

      it 'false for user when resource is not set' do
        authorization = Authorization.new(nil, nil)
        expect(authorization.permitted).to be_falsey
      end
    end
  end
end
