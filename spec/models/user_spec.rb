require 'rails_helper'

RSpec.describe User, type: :model do
  let(:params) do
    { login: rand_text, password: 'secret', email: rand_text }
  end

  it 'Create new user' do
    user = User.new params
    expect(user.save!).to be_truthy
  end
end
