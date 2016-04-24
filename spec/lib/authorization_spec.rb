require 'rails_helper'

RSpec.describe Authorization, type: :class do
  describe '#permitted' do
    let!(:user) { create(:user) }
    let(:object) { FakeObject.new user.id }

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
    end

    it 'should be false for guest' do
      user = Guest.new
      authorization = Authorization.new(user, nil)
      expect(authorization.permitted).to be_falsey
    end
  end
end
