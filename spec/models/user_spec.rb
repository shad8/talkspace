require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:posts) }
  it { is_expected.to have_many(:categories) }
  it { is_expected.to have_many(:sessions) }

  it { is_expected.to validate_presence_of(:login) }
  it { is_expected.to validate_presence_of(:email) }

  it 'can not create user with empty password' do
    user = User.new(password: '', login: rand_text, email: rand_email)
    expect(user).to_not be_valid
  end

  it { is_expected.to validate_uniqueness_of(:login) }
  it { is_expected.to validate_uniqueness_of(:email) }

  it { is_expected.to validate_length_of(:password).is_at_least(5) }

  it { is_expected.to define_enum_for(:role).with([:user, :admin]) }
end
