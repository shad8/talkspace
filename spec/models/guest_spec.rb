require 'rails_helper'

RSpec.describe Guest, type: :model do
  it { is_expected.to callback(:set_role).after(:initialize) }
  it { is_expected.to be_kind_of(User) }

  describe '#owner?' do
    it 'for nil resource should be true' do
      user = Guest.new
      expect(user.owner?).to be_falsey
    end
  end
end
