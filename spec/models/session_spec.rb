require 'rails_helper'

RSpec.describe Session, type: :model do
  let(:user) { create(:user) }
  subject { Session.create(user: user) }
  it 'belongs_to User' do
    expect(subject.user).to eq user
  end

  it 'has generated token' do
    expect(subject.token).to be
  end
end
