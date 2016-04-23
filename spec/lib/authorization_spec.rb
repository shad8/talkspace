require 'rails_helper'

RSpec.describe Authorization, type: :class do
  describe '#permitted' do
    let!(:user) { create(:user) }
    let(:object) { FakeObject.new user }

    context 'should be true' do
      it 'for admin' do
        user.update(role: :admin)
        authorization = Authorization.new(user, object)
        expect(authorization.permitted).to be_truthy
      end

      it 'for owner' do
        authorization = Authorization.new(user, object)
        expect(authorization.permitted).to be_truthy
      end

      it 'for user when resource is not set' do
        authorization = Authorization.new(user, nil)
        expect(authorization.permitted).to be_truthy
      end
    end
  end
end
