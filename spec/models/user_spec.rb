require 'rails_helper'

RSpec.describe User, type: :model do
  let(:params) do
    { login: rand_text, password: 'secret', email: rand_text }
  end

  it 'is valid' do
    user = User.new params
    expect(user.save!).to be_truthy
  end

  context 'is invalid' do
    [:login, :email, :password].each do |attribute|
      it "for blank #{attribute}" do
        params[attribute] = ''
        user = User.new params
        expect(user.save).to be_falsey
      end
    end

    it 'for to short password ' do
      params[:password] = rand_text(3)
      user = User.new(params)
      expect(user.save).to be_falsey
    end

    it 'for not unique login' do
      params[:login] = create(:user).login
      user = User.new(params)
      expect(user.save).to be_falsey
    end

    it 'for not unique email' do
      params[:email] = create(:user).email
      user = User.new(params)
      expect(user.save).to be_falsey
    end
  end
end
