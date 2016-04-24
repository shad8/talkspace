require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:posts) }
  it { is_expected.to have_many(:categories) }

  it { is_expected.to validate_presence_of(:login) }
  it { is_expected.to validate_presence_of(:email) }

  it { is_expected.to callback(:generate_token).before(:create) }

  it 'can not create user with empty password' do
    user = User.new(password: '', login: rand_text, email: rand_email)
    expect(user).to_not be_valid
  end

  it { is_expected.to validate_uniqueness_of(:login) }
  it { is_expected.to validate_uniqueness_of(:email) }

  it { is_expected.to validate_length_of(:password).is_at_least(5) }

  it { is_expected.to define_enum_for(:role).with([:user, :admin, :guest]) }

  describe '#owner?' do
    let(:user) { create(:user) }

    it 'for nil resource should be true' do
      expect(user.owner?).to be_truthy
    end

    it 'for corresponding resource should be true' do
      object = FakeObject.new user.id
      expect(user.owner?(object)).to be_truthy
    end

    it 'for not corresponding resource should be true' do
      object = FakeObject.new rand(10) + 10
      expect(user.owner?(object)).to be_falsey
    end
  end
end
